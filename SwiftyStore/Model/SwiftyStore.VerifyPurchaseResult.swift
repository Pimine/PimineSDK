//
//  SwiftyStore.VerifyPurchaseResult.swift
//  Pimine
//
//  Created by Den Andreychuk on 19.12.2020.
//  Copyright © 2020 Pimine. All rights reserved.
//

import SwiftyStoreKit

public extension SwiftyStore {
enum VerifyPurchaseResult {
    case purchased(item: ReceiptItem)
    case notPurchased
    case failed(FailureReason)
    
    public enum FailureReason: Error {
        case generalError(Error)
        case receiptError(ReceiptError)
    }
}}
