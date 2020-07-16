//
//  SubscriptionInterfaceController.swift
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

import Purchases

extension RevenueCat {
final public class SubscriptionInterfaceController {
    
    // MARK: - Public properties
    
    public weak var delegate: RCSubscriptionInterfaceControllerDelegate?
    
    public let merchant: RevenueCat.Merchant
    
    public var offering: Purchases.Offering?
    
    public var availablePackages: [Purchases.Package] {
        offering?.availablePackages ?? []
    }

    // MARK: - Initialization
    
    public init(merchant: RevenueCat.Merchant) {
        self.merchant = merchant
    }
    
    // MARK: - Public API
    
    public func fetchOffering() {
        changeFetchingState(to: .loading)
        Purchases.shared.offerings { (offerings, error) in
            if let error = error {
                self.changeFetchingState(to: .failed(.revenueCatError(error)))
            }
            guard let offering = offerings?.current else {
                let error = PMGeneralError(message: "An error occured when fetching current offering.")
                self.changeFetchingState(to: .failed(.genericProblem(error)))
                return
            }
            self.offering = offering
            self.changeFetchingState(to: .dormant)
        }
    }
    
    public func restorePurchases() {
        Purchases.shared.restoreTransactions { (purchaserInfo, error) in
            if let error = error {
                self.resolvePurchasesRestoring(with: .failure(error))
            }
            guard let purchaserInfo = purchaserInfo else { return }
            self.resolvePurchasesRestoring(with: .success(purchaserInfo.activeSubscriptions))
            self.merchant.updatePurchaserInfo()
        }
    }
    
    // MARK: - Helpers
    
    public func state(for package: Package) -> PackageState {
        if offering.isNil { return .unknown }
        
        guard let package = availablePackages.first(where: { $0.identifier == package.identifier }) else {
            return .packageUnavailable
        }
        return .purchasable(package)
    }
    
    private func changeFetchingState(to state: FetchingState) {
        delegate?.subscriptionInterfaceController(self, didChangeFetchingStateTo: state)
    }
    
    private func resolvePurchasesRestoring(with result: RestorePurchasesResult) {
        self.delegate?.subscriptionInterfaceController(self, didRestorePurchasesWith: result)
    }
}}

// MARK: - Typealias

public extension RevenueCat.SubscriptionInterfaceController {
    
    typealias RestorePurchasesResult = Swift.Result<Set<String>, Error>
}

// MARK: - ProductState

public extension RevenueCat.SubscriptionInterfaceController {
    
    enum PackageState : Equatable {
        case unknown
        case purchasable(Purchases.Package)
        case packageUnavailable
    }
}

// MARK: - FetchingState

public extension RevenueCat.SubscriptionInterfaceController {
    
    enum FetchingState {
        case loading
        case failed(FailureReason)
        case dormant
        
        public enum FailureReason {
            case genericProblem(Error)
            case revenueCatError(Error)
        }
    }
}
