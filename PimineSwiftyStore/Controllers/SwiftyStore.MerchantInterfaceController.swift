import PimineUtilities
import SwiftyStoreKit
import SVProgressHUD

extension SwiftyStore {
open class MerchantInterfaceController: RestoringInterfaceController {
    
    // MARK: - Public API
    
    open func fetchDataIfNecessary() {
        productInterfaceController.fetchDataIfNecessary()
    }
    
    open func purchaseProduct(_ product: Product) {
        SVProgressHUD.show()
        productInterfaceController.purchaseProduct(product)
    }
    
    open override func productInterfaceController(
        _ controller: SwiftyStore.ProductInterfaceController,
        didCommitPurchaseOf product: SwiftyStore.Product,
        with result: SwiftyStore.CommitPurchaseResult
    ) {
        super.productInterfaceController(controller, didCommitPurchaseOf: product, with: result)
        
        SVProgressHUD.dismiss()
        guard case let .failure(error) = result else { return }
        
        switch error {
        case .storeKitError(let skError):
            switch skError.code {
            case .paymentCancelled:
                break
            case .storeProductNotAvailable:
                PMAlert.show(title: messageProvider.error, message: messageProvider.storeProductNotAvailable)
            case .paymentNotAllowed:
                PMAlert.show(title: messageProvider.error, message: messageProvider.paymentNotAllowed)
            case .paymentInvalid:
                PMAlert.show(title: messageProvider.error, message: messageProvider.paymentInvalid)
            default:
                let errorCode = skError.errorCode
                PMAlert.show(
                    title: messageProvider.error,
                    message: "\(messageProvider.storeCommunicationError) (Error code: \(errorCode))"
                )
            }
        case .receiptError(let error):
            handleReceiptError(error)
        case .genericProblem(let error):
            PMAlert.show(title: messageProvider.error, message: "\(messageProvider.error). \(error.localizedDescription)")
        }
    }
    
    // MARK: - Helpers
    
    private func handleReceiptError(_ error: ReceiptError) {
        switch error {
        case .noReceiptData:
            PMAlert.show(
                title: messageProvider.error,
                message: messageProvider.noReceiptData
            )
        case .networkError(error: let error):
            PMAlert.show(
                title: messageProvider.error,
                message: "\(messageProvider.verificationNetworkProblem): \(error.localizedDescription)"
            )
        default:
            PMAlert.show(
                title: messageProvider.error,
                message: "\(messageProvider.verificationFailed): \(error.localizedDescription)"
            )
        }
    }
    
    public func price(for product: Product) -> Price? {
        productInterfaceController.price(for: product)
    }
}}
