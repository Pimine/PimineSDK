//
//  SwiftyStore.MerchantController.swift
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

import StoreKit
import SVProgressHUD
import SwiftyStoreKit
import PimineUtilities

extension SwiftyStore {
open class MerchantController: RestoringController {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        productInterfaceController.fetchDataIfNecessary()
    }
    
    // MARK: - Public API
    
    open func purchaseProduct(_ product: Product) {
        SVProgressHUD.show()
        productInterfaceController.purchaseProduct(product)
    }
    
    open override func productInterfaceController(
        _ controller: SwiftyStore.ProductInterfaceController,
        didCommitPurchaseOf product: SwiftyStore.Product,
        with result: SwiftyStore.CommitPurchaseResult
    ) {
        SVProgressHUD.dismiss()
        guard case let .failure(error) = result else { return }
        
        switch error {
        case .storeKitError(let skError):
            switch skError.code {
            case .paymentCancelled:
                break
            case .storeProductNotAvailable:
                PMAlert.show(message: messageProvider.storeProductNotAvailable)
            case .paymentNotAllowed:
                PMAlert.show(message: messageProvider.paymentNotAllowed)
            case .paymentInvalid:
                PMAlert.show(message: messageProvider.paymentInvalid)
            default:
                let errorCode = skError.errorCode
                PMAlert.show(message: "\(messageProvider.storeCommunicationError) (Error code: \(errorCode))")
            }
        case .receiptError(let error):
            handleReceiptError(error)
        case .genericProblem(let error):
            PMAlert.show(message: "\(messageProvider.error). \(error.localizedDescription)")
        }
    }
    
    // MARK: - Helpers
    
    private func handleReceiptError(_ error: ReceiptError) {
        switch error {
        case .noReceiptData:
            PMAlert.show(message: messageProvider.noReceiptData)
        case .networkError(error: let error):
            PMAlert.show(message: "\(messageProvider.verificationNetworkProblem): \(error.localizedDescription)")
        default:
            PMAlert.show(message: "\(messageProvider.verificationFailed): \(error.localizedDescription)")
        }
    }
    
    public func price(for product: Product) -> Price? {
        productInterfaceController.price(for: product)
    }
}}
