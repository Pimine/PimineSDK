//
//  SwiftyStore.Merchant.swift
//  https://github.com/Pimine/PimineSDK
//
//  This code is distributed under the terms and conditions of the MIT license.
//  Copyright (c) 2020 Pimine
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation
import SwiftyStoreKit

extension SwiftyStore {
public final class Merchant {
    
    public weak var delegate: SwiftyStoreMerchantDelegate?
    
    private(set) var products = [String: Product]()
    
    private let sharedSecret: String
    
    // MARK: - Initialization
    
    public init(sharedSecret: String, delegate: SwiftyStoreMerchantDelegate) {
        self.sharedSecret = sharedSecret
        self.delegate = delegate
    }
    
    // MARK: - Setup
    
    public func register(_ products: Set<Product>) {
        products.forEach {
            self.products[$0.identifier] = $0
        }
    }
    
    public func setup() {
        setupTransactionObserver()
    }
    
    private func setupTransactionObserver() {
        SwiftyStoreKit.completeTransactions { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    guard let product = self.products[purchase.productId] else { return }
                    switch product.kind {
                    case .consumable, .nonConsumable:
                        self.verifyPurchase(product: product)
                    case .subscription:
                        self.verifySubscription(product)
                    }
                case .failed, .deferred, .purchasing:
                    break
                @unknown default:
                    break
                }
            }
        }
    }
    
    // MARK: - Purchases restoration
    
    public func restorePurchases(complection: @escaping (RestorePurchasesResult) -> Void = { _ in }) {
        SwiftyStoreKit.restorePurchases { result in
            let restorePurchasesResult: RestorePurchasesResult
            
            if result.restoreFailedPurchases.count > 0 {
                let error = PMGeneralError(message: Messages.restoreFailed)
                restorePurchasesResult = .failure(error)
            } else {
                restorePurchasesResult = .success(result.restoredPurchases)
            }
            self.delegate?.merchant(self, didRestorePurchasesWith: restorePurchasesResult)
            complection(restorePurchasesResult)
        }
    }
    
    // MARK: - Purchases verification
    
    public func verifySubscriptions(
        _ subscriptions: Set<Product>,
        forceRefresh: Bool = false,
        completion: @escaping (VerifySubscriptionResult) -> Void = { _ in }
    ) {
        var result: VerifySubscriptionResult!
        
        if subscriptions.contains(where: {
            if case .subscription = $0.kind { return false }; return true
        }) {
            let error = PMGeneralError(message: Messages.wrongProductType)
            result = .failed(.generalError(error))
            self.delegate?.merchant(self, verifiedSubscriptions: subscriptions, with: result)
            return completion(result)
        }
        
        verifyReceipt(forceRefresh: forceRefresh) { (verifyReceiptResult) in
            
            switch verifyReceiptResult {
            case .success(let receipt):
                result = self.processSubscriptions(subscriptions, in: receipt)
            case .error(let error):
                result = .failed(.receiptError(error))
            }
            
            self.delegate?.merchant(self, verifiedSubscriptions: subscriptions, with: result)
            return completion(result)
        }
    }
    
    public func verifySubscription(
        _ subscription: Product,
        forceRefresh: Bool = false,
        completion: @escaping (VerifySubscriptionResult) -> Void = { _ in }
    ) {
        var result: VerifySubscriptionResult!
        
        guard case .subscription = subscription.kind else {
            let error = PMGeneralError(message: Messages.wrongProductType)
            result = .failed(.generalError(error))
            self.delegate?.merchant(self, verifiedSubscriptions: Set([subscription]), with: result)
            return completion(result)
        }
        
        verifyReceipt(forceRefresh: forceRefresh) { (verifyReceiptResult) in
            
            switch verifyReceiptResult {
            case .success(let receipt):
                result = self.processSubscriptions(Set([subscription]), in: receipt)
            case .error(let error):
                result = .failed(.receiptError(error))
            }
            
            self.delegate?.merchant(self, verifiedSubscriptions: Set([subscription]), with: result)
            return completion(result)
        }
    }
    
    func verifyPurchase(
        product: Product,
        forceRefresh: Bool = false,
        completion: @escaping (VerifyPurchaseResult) -> Void = { _ in }
    ) {
        // TODO: - Implement verification for non-consumable, consumable purchases.
    }
    
    private func verifyReceipt(forceRefresh: Bool = false, result: @escaping (VerifyReceiptResult) -> Void) {
        #if DEBUG
        let service = AppleReceiptValidator.VerifyReceiptURLType.sandbox
        #else
        let service = AppleReceiptValidator.VerifyReceiptURLType.production
        #endif
        
        let validator = AppleReceiptValidator(service: service, sharedSecret: sharedSecret)
        SwiftyStoreKit.verifyReceipt(using: validator, forceRefresh: forceRefresh) { (verifyResult) in
            result(verifyResult)
        }
    }
    
    private func processSubscriptions(
        _ subscriptions: Set<Product>,
        in receipt: ReceiptInfo
    ) -> VerifySubscriptionResult {
        let verifySubscriptionResult = SwiftyStoreKit.verifySubscriptions(
            productIds: Set(subscriptions.map(\.identifier)),
            inReceipt: receipt
        )
        
        let result: VerifySubscriptionResult!
        
        switch verifySubscriptionResult {
        case .purchased(let expiryDate, let items):
            result = .purchased(expiryDate: expiryDate, items: items)
        case .expired(let expiryDate, let items):
            result = .expired(expiryDate: expiryDate, items: items)
        case .notPurchased:
            result = .notPurchased
        }
        
        return result
    }
}}

