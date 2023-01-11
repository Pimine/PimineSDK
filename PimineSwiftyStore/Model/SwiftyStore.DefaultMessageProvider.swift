//
//  SwiftyStore.DefaultMessageProvider.swift
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

import Foundation
import PimineUtilities

extension SwiftyStore {
    public struct DefaultMessageProvider: SwiftyStoreMessageProvider {
        
        public var verificationFailed = "Receipt verification failed"
        public var wrongProductType = "Receipt verification failed. Wrong product type."
        public var verificationNetworkProblem = "Network error while verifying receipt"
        public var noReceiptData = "Receipt verification failed. No receipt data. \(PMessages.tryAgain)."
        public var productPurchased = PMessages.productPurchased
        public var unknownProductState = PMessages.unknownProductState
        public var paymentInvalid = PMessages.paymentInvalid
        public var storeProductNotAvailable = PMessages.productNotAvailable
        public var notAuthorized = PMessages.notAuthorized
        public var purchasesMayBeRestricted = PMessages.purchasesMayBeRestricted
        public var paymentNotAllowed = PMessages.cannotMakePayments
        public var storeCommunicationError = PMessages.storeCommunicationError
        public var restored = PMessages.restored
        public var nothingToRestore = PMessages.nothingToRestore
        public var restorationFailed = PMessages.restorationFailed
        public var error = PMessages.error
        public var info = PMessages.info
        public var somethingWentWrong = PMessages.somethingWentWrong
        
        public init() { }
    }
}
