//
//  RevenueCat.MerchantController.swift
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
import SVProgressHUD
import PimineUtilities

extension RevenueCat {
open class MerchantController: RestoringController {
    
    // MARK: - View controller lifecycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        subscriptionInterfaceController.fetchOffering()
    }
    
    // MARK: - Public API
    
    public func purchasePackage(type packageType: Purchases.PackageType) {
        SVProgressHUD.show()
        subscriptionInterfaceController.purchasePackage(type: packageType)
    }
    
    // MARK: - RevenueCatDelegate

    override open func subscriptionInterfaceController(
        _ controller: RevenueCat.SubscriptionInterfaceController,
        didCommitPurchaseWith result: RevenueCat.SubscriptionInterfaceController.CommitPurchaseResult
    ) {
        SVProgressHUD.dismiss()
        guard case let .failure(error) = result else { return }
        
        switch error {
        case .userCancelled:
            break
        case .genericProblem(let error), .revenueCatError(let error):
            PMAlert.show(error: error)
        }
    }
}}
