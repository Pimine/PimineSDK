//
//  SwiftyStore.RestoringController.swift
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
import SVProgressHUD

extension SwiftyStore {
open class RestoringController: UIViewController, SwiftyStoreInterfaceDelegate {
    
    // MARK: - Properties
    
    public let productInterfaceController: SwiftyStore.ProductInterfaceController
    
    // MARK: - Initialization
    
    public init(products: Set<Product>, with merchant: Merchant) {
        self.productInterfaceController = ProductInterfaceController(products: products, with: merchant)
        super.init(nibName: nil, bundle: nil)
        productInterfaceController.delegate = self
    }
    
    required public init?(coder: NSCoder) {
        fatalError("RestoringController do not support Storyboards. Please, use init(merchant:products:) instead.")
    }
    
    // MARK: - Public API
    
    open func restorePurchases() {
        SVProgressHUD.show()
        productInterfaceController.restorePurchases()
    }
    
    // MARK: - SwiftyStoreInterfaceDelegate
    
    open func productInterfaceController(
        _ controller: ProductInterfaceController,
        didRestorePurchasesWith result: RestorePurchasesResult
    ) {
        SVProgressHUD.dismiss()
        switch result {
        case .success(let products) where products.count > 0:
            PMAlert.show(title: PMessages.info, message: PMessages.restored)
        case .success:
            PMAlert.show(message: PMessages.nothingToRestore)
        case .failure(let error):
            PMAlert.show(error: error)
        }
    }
    
    open func productInterfaceController(
        _ controller: ProductInterfaceController,
        didChangeFetchingStateTo state: ProductInterfaceController.FetchingState
    ) { }
    
    open func productInterfaceController(
        _ controller: ProductInterfaceController,
        didCommitPurchaseWith result: CommitPurchaseResult
    ) { }
}}
