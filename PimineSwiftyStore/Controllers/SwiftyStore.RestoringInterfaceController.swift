import PimineUtilities
import SwiftyStoreKit
import SVProgressHUD

extension SwiftyStore {
open class RestoringInterfaceController: SwiftyStoreInterfaceDelegate {
    
    // MARK: - Properties
    
    public weak var delegate: SwiftyStoreInterfaceDelegate?
    
    public let productInterfaceController: SwiftyStore.ProductInterfaceController
    public let messageProvider: SwiftyStoreMessageProvider
    
    // MARK: - Initialization
    
    public init(
        products: Set<Product>, with
        merchant: Merchant,
        messageProvider: SwiftyStoreMessageProvider = DefaultMessageProvider()
    ) {
        self.productInterfaceController = ProductInterfaceController(products: products, with: merchant)
        self.messageProvider = messageProvider
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
        delegate?.productInterfaceController(controller, didRestorePurchasesWith: result)
        
        SVProgressHUD.dismiss()
        switch result {
        case .success(let products) where products.count > 0:
            PMAlert.show(title: messageProvider.info, message: messageProvider.restored)
        case .success:
            PMAlert.show(message: messageProvider.nothingToRestore)
        case .failure(let error):
            PMAlert.show(error: error)
        }
    }
    
    open func productInterfaceController(
        _ controller: ProductInterfaceController,
        didChangeFetchingStateTo state: ProductInterfaceController.FetchingState
    ) {
        delegate?.productInterfaceController(controller, didChangeFetchingStateTo: state)
    }
    
    open func productInterfaceController(
        _ controller: SwiftyStore.ProductInterfaceController,
        didCommitPurchaseOf product: SwiftyStore.Product,
        with result: SwiftyStore.CommitPurchaseResult
    ) {
        delegate?.productInterfaceController(controller, didCommitPurchaseOf: product, with: result)
    }
}}
