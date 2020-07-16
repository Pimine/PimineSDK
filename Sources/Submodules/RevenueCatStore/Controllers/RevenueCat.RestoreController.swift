//
//  PurchasesRestoringController.swift
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

import SVProgressHUD

extension RevenueCat {
open class RestoreController: UIViewController, RCSubscriptionInterfaceControllerDelegate {
    
    // MARK: - Properties
    
    public let subscriptionInterfaceController: RevenueCat.SubscriptionInterfaceController
    
    // MARK: - Initialization
    
    public init(merchant: RevenueCat.Merchant) {
        self.subscriptionInterfaceController = RevenueCat.SubscriptionInterfaceController(merchant: merchant)
        super.init(nibName: nil, bundle: nil)
        self.subscriptionInterfaceController.delegate = self
    }
    
    required public init?(coder: NSCoder) {
        fatalError("RestoreController do not support Storyboards. Please, use init(merchant:) instead.")
    }
    
    // MARK: - View controller lifecycle
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
    // MARK: - Public API
    
    public func restorePurchases() {
        SVProgressHUD.show()
        subscriptionInterfaceController.restorePurchases()
    }
    
    // MARK: - Helpers
    
    public func price(for package: Package) -> Price? {
        subscriptionInterfaceController.price(for: package)
    }
    
    // MARK: - RCSubscriptionInterfaceControllerDelegate
    
    open func subscriptionInterfaceController(
        _ controller: RevenueCat.SubscriptionInterfaceController,
        didRestorePurchasesWith result: RevenueCat.SubscriptionInterfaceController.RestorePurchasesResult
    ) {
        SVProgressHUD.dismiss()
        switch result {
        case .success(let products) where products.count > 0:
            PMAlert.show(message: RevenueCat.Messages.restored)
        case .success:
            PMAlert.show(message: RevenueCat.Messages.nothingToRestore)
        case .failure(let error):
            PMAlert.show(error: error)
        }
    }
}}
