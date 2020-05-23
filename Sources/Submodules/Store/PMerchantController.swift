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

open class PMerchantController: UIViewController, ProductInterfaceControllerDelegate {

    // MARK: - Public properties

    public let productInterfaceController: ProductInterfaceController
    
    // MARK: - Initialization
    
    public init(merchant: Merchant, products: Set<Product>) {
        self.productInterfaceController = ProductInterfaceController(products: products, with: merchant)
        super.init(nibName: nil, bundle: nil)
        productInterfaceController.delegate = self
    }
    
    required public init?(coder: NSCoder) {
        fatalError("PMerchantController do not support Storyboards. Please, use init(merchant:products:) instead.")
    }
    
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
            PMAlert.show(message: StoreMessages.unknownProductState)
        case .purchasable(let purchase):
            commitPurchase(purchase)
        case .purchased:
            PMAlert.show(message: StoreMessages.productPurchased)
        case .purchaseUnavailable:
            PMAlert.show(message: StoreMessages.productNotAvailable)
        case .purchasing:
            break
        }
    }
    
    open func restorePurchases() {
        SVProgressHUD.show()
        productInterfaceController.restorePurchases()
    }
    
    // MARK: - ProductInterfaceControllerDelegate
    
    open func productInterfaceControllerDidChangeFetchingState(_ controller: ProductInterfaceController) {
        guard case let .failed(reason) = controller.fetchingState else { return }
        handleFetchingFailure(reason)
    }
    
    open func productInterfaceController(
        _ controller: ProductInterfaceController,
        didChangeStatesFor products: Set<Product>) { }
    
    open func productInterfaceController(
        _ controller: ProductInterfaceController,
        didCommit purchase: Purchase,
        with result: ProductInterfaceController.CommitPurchaseResult
    ) {
        SVProgressHUD.dismiss()
        guard case let .failure(error) = result else { return }
        handlePurchaseError(error)
    }
    
    open func productInterfaceController(
        _ controller: ProductInterfaceController,
        didRestorePurchasesWith result: ProductInterfaceController.RestorePurchasesResult
    ) {
        SVProgressHUD.dismiss()
        switch result {
        case .success(let products) where products.count > 0:
            PMAlert.show(message: StoreMessages.restored)
        case .success:
            PMAlert.show(message: StoreMessages.nothingToRestore)
        case .failure(let error):
            PMAlert.show(error: error)
        }
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
            PMAlert.show(message: "\(StoreMessages.storeCommunicationError) (Error code: \(errorCode))")
        case .genericProblem:
            PMAlert.show(message: StoreMessages.error)
        }
    }
    
    private func handlePurchaseError(_ error: ProductInterfaceController.CommitPurchaseError) {
        switch error {
        case .userCancelled:
            break
        case .networkError(let error):
            PMAlert.show(error: error)
        case .purchaseNotAvailable:
            PMAlert.show(message: StoreMessages.productNotAvailable)
        case .paymentNotAllowed:
            PMAlert.show(message: StoreMessages.cannotMakePayments)
        case .paymentInvalid:
            PMAlert.show(message: StoreMessages.paymentInvalid)
        case .genericProblem(let error) where error is SKError:
            let errorCode = (error as! SKError).errorCode
            PMAlert.show(message: "\(StoreMessages.storeCommunicationError) (Error code: \(errorCode)")
        case .genericProblem(let error):
            PMAlert.show(message: "\(StoreMessages.error) \(error.localizedDescription)")
        }
    }
}

