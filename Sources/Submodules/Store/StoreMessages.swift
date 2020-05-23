//
//  StoreMessages.swift
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

struct StoreMessages {
    
    static let error = "There was an error."
    
    // MARK: - Messages related to product state
    
    static let productPurchased = "You have already bought this product."
    static let unknownProductState = "Unable to fetch product information."
    
    // MARK: - Commit purchase error messages
    
    static let productNotAvailable = "The product is not available in the current storefront."
    
    static let paymentInvalid = "One of the payment parameters was not recognized by the App Store."
    static let storeCommunicationError = "There was an error communicating with the iTunes Store."
    
    static let notAuthorized = "You are not authorized to make payments."
    static let purchasesMayBeRestricted = "In-App Purchases may be restricted on your device."
    static let cannotMakePayments = "\(notAuthorized) \(purchasesMayBeRestricted)"
    
    // MARK: - Restore purchases result messages
    
    static var restored = "All transactions have been successfully restored."
    static var nothingToRestore = "There are no transactions that could be restored."
    
}
