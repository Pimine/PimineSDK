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

extension SwiftyStore {
    public struct DefaultMessageProvider: SwiftyStoreMessageProvider {
        
        public var verificationFailed: String {
            "Receipt verification failed"
        }
        
        public var wrongProductType: String {
            "\(verificationFailed). Wrong product type."
        }
        
        public var verificationNetworkProblem: String {
            "Network error while verifying receipt"
        }
        
        public var noReceiptData: String {
            "\(verificationFailed). No receipt data. \(PMessages.tryAgain)."
        }
        
        public var productPurchased: String {
            PMessages.productPurchased
        }
        
        public var unknownProductState: String {
            PMessages.unknownProductState
        }
        
        public var paymentInvalid: String {
            PMessages.paymentInvalid
        }
        
        public var productNotAvailable: String {
            PMessages.productNotAvailable
        }
        
        public var notAuthorized: String {
            PMessages.notAuthorized
        }
        
        public var purchasesMayBeRestricted: String {
            PMessages.purchasesMayBeRestricted
        }
        
        public var cannotMakePayments: String {
            PMessages.cannotMakePayments
        }
        
        public var storeCommunicationError: String {
            PMessages.storeCommunicationError
        }
        
        public var restored: String {
            PMessages.restored
        }
        
        public var nothingToRestore: String {
            PMessages.nothingToRestore
        }
        
        public var restorationFailed: String {
            PMessages.restorationFailed
        }
        
        public var error: String {
            PMessages.error
        }
        
        public var info: String {
            PMessages.info
        }
        
        public var somethingWentWrong: String {
            PMessages.somethingWentWrong
        }
        
        public init() { }
    }
}
