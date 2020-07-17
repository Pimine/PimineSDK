//
//  PMerchantController.swift
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

import MerchantKit
import SVProgressHUD

extension LocalStore {
open class MerchantController: LocalStore.RestoringController {
    
    // MARK: - View controller lifecycle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        productInterfaceController.fetchDataIfNecessary()
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }

    // MARK: - Public API
    
    open func buy(_ product: Product) {
        let productState = productInterfaceController.state(for: product)
        
        switch productState {
        case .unknown:
            PMAlert.show(message: LocalStore.Messages.unknownProductState)
        case .purchasable(let purchase):
            commitPurchase(purchase)
        case .purchased:
            PMAlert.show(message: LocalStore.Messages.productPurchased)
        case .purchaseUnavailable:
            PMAlert.show(message: LocalStore.Messages.productNotAvailable)
        case .purchasing:
            break
        }
    }
    
    // MARK: - ProductInterfaceControllerDelegate
    
    override open func productInterfaceControllerDidChangeFetchingState(_ controller: ProductInterfaceController) {
        guard case let .failed(reason) = controller.fetchingState else { return }
        handleFetchingFailure(reason)
    }
    
    override open func productInterfaceController(
        _ controller: ProductInterfaceController,
        didCommit purchase: Purchase,
        with result: ProductInterfaceController.CommitPurchaseResult
    ) {
        SVProgressHUD.dismiss()
        guard case let .failure(error) = result else { return }
        handlePurchaseError(error)
    }
    
    // MARK: - Private methods
    
    private func commitPurchase(_ purchase: Purchase) {
        SVProgressHUD.show()
        productInterfaceController.commit(purchase)
    }
    
    private func handleFetchingFailure(_ reason: ProductInterfaceController.FetchingState.FailureReason) {
        switch reason {
        case .networkFailure(let error):
            PMAlert.show(error: error)
        case .storeKitFailure(let error):
            let errorCode = error.errorCode
            PMAlert.show(message: "\(LocalStore.Messages.storeCommunicationError) (Error code: \(errorCode))")
        case .genericProblem:
            PMAlert.show(message: LocalStore.Messages.error)
        }
    }
    
    private func handlePurchaseError(_ error: ProductInterfaceController.CommitPurchaseError) {
        switch error {
        case .userCancelled:
            break
        case .networkError(let error):
            PMAlert.show(error: error)
        case .purchaseNotAvailable:
            PMAlert.show(message: LocalStore.Messages.productNotAvailable)
        case .paymentNotAllowed:
            PMAlert.show(message: LocalStore.Messages.cannotMakePayments)
        case .paymentInvalid:
            PMAlert.show(message: LocalStore.Messages.paymentInvalid)
        case .genericProblem(let error) where error is SKError:
            let errorCode = (error as! SKError).errorCode
            PMAlert.show(message: "\(LocalStore.Messages.storeCommunicationError) (Error code: \(errorCode)")
        case .genericProblem(let error):
            PMAlert.show(message: "\(LocalStore.Messages.error) \(error.localizedDescription)")
        }
    }
}}

