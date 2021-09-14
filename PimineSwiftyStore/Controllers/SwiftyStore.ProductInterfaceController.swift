//
//  SwiftyStore.ProductInterfaceController.swift
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

import PimineUtilities
import SwiftyStoreKit
import StoreKit

extension SwiftyStore {
final public class ProductInterfaceController {
    
    public weak var delegate: SwiftyStoreInterfaceDelegate?
    
    private let merchant: SwiftyStore.Merchant
    
    private var products: [String: Product] = [:]
    
    private let productIdentifiers: Set<String>
    
    private var productStates: [String: ProductState] = [:]
    
    // MARK: - Initialization
    
    public init(products: Set<Product>, with merchant: SwiftyStore.Merchant) {
        self.merchant = merchant
        self.productIdentifiers = Set(products.map(\.identifier))
        
        products.forEach {
            self.productStates[$0.identifier] = .unknown
            self.products[$0.identifier] = $0
        }
    }
    
    // MARK: - Public API
    
    public func fetchDataIfNecessary() {
        changeFetchingState(to: .loading)
        SwiftyStoreKit.retrieveProductsInfo(productIdentifiers) { (result) in
            result.retrievedProducts.forEach {
                let price = Price(price: $0.price, locale: $0.priceLocale)
                self.productStates[$0.productIdentifier] = .purchasable(price)
            }

            result.invalidProductIDs.forEach {
                self.productStates[$0] = .unavailable
            }

            result.error.isNil ?
                self.changeFetchingState(to: .dormant) :
                self.changeFetchingState(to: .failed(result.error!))
        }
    }
    
    public func purchaseProduct(_ product: Product) {
        SwiftyStoreKit.purchaseProduct(product.identifier) { (result) in
            switch result {
            case .success(let purchaseDetails):
                self.verifyPurchase(product: product, purchaseDetails: purchaseDetails)
            case .error(let error):
                switch error {
                case SKError.paymentCancelled:
                    self.resolvePurchaseTask(with: .failure(.userCancelled))
                case SKError.storeProductNotAvailable:
                    self.resolvePurchaseTask(with: .failure(.purchaseNotAvailable))
                case SKError.paymentNotAllowed:
                    self.resolvePurchaseTask(with: .failure(.paymentNotAllowed))
                default:
                    self.resolvePurchaseTask(with: .failure(.genericProblem(error)))
                }
            }
        }
    }

    public func restorePurchases() {
        merchant.restorePurchases { result in
            self.resolveRestoreTask(with: result)
        }
    }
    
    // MARK: - Private API
    
    private func verifyPurchase(product: Product, purchaseDetails: PurchaseDetails) {
        switch product.kind {
        case .consumable, .nonConsumable:
            merchant.verifyPurchase(product) { (verifyPurchaseResult) in
                switch verifyPurchaseResult {
                case .purchased:
                    self.resolvePurchaseTask(with: .success(purchaseDetails))
                case .notPurchased:
                    let error = PMGeneralError(message: PMessages.somethingWentWrong)
                    self.resolvePurchaseTask(with: .failure(.genericProblem(error)))
                case .failed(let reason):
                    switch reason {
                    case .generalError(let error):
                        self.resolvePurchaseTask(with: .failure(.genericProblem(error)))
                    case .receiptError(let error):
                        self.resolvePurchaseTask(with: .failure(.receiptError(error)))
                    }
                }
            }
        case .subscription:
            merchant.verifySubscription(product) { (verifySubscriptionResult) in
                switch verifySubscriptionResult {
                case .purchased:
                    self.resolvePurchaseTask(with: .success(purchaseDetails))
                case .expired, .notPurchased:
                    let error = PMGeneralError(message: PMessages.somethingWentWrong)
                    self.resolvePurchaseTask(with: .failure(.genericProblem(error)))
                case .failed(let reason):
                    switch reason {
                    case .generalError(let error):
                        self.resolvePurchaseTask(with: .failure(.genericProblem(error)))
                    case .receiptError(let error):
                        self.resolvePurchaseTask(with: .failure(.receiptError(error)))
                    }
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    public func state(for product: Product) -> ProductState {
        productStates[product.identifier] ?? .unknown
    }
    
    public func price(for product: Product) -> Price? {
        guard case .purchasable(let price) = state(for: product) else { return nil }
        return price
    }
    
    private func changeFetchingState(to state: FetchingState) {
        delegate?.productInterfaceController(self, didChangeFetchingStateTo: state)
    }
    
    private func resolvePurchaseTask(with result: CommitPurchaseResult) {
        delegate?.productInterfaceController(self, didCommitPurchaseWith: result)
        merchant.didCommitPurchase(result: result)
    }
    
    private func resolveRestoreTask(with result: RestorePurchasesResult) {
        delegate?.productInterfaceController(self, didRestorePurchasesWith: result)
    }
}}

// MARK: - ProductState

public extension SwiftyStore.ProductInterfaceController {

    enum ProductState {
        case purchasable(SwiftyStore.Price)
        case unavailable
        case unknown
    }
}

// MARK: - FetchingState

public extension SwiftyStore.ProductInterfaceController {

    enum FetchingState {
        case loading
        case dormant
        case failed(Error)
    }
}

