//
//  PMessages.swift
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

public struct PMessages {
    
    // MARK: - General
    
    public static let info = "Info"
    public static let whoops = "Whoops"
    public static let error = "There was an error"
    public static let tryAgain = "Please try again"
    public static let contactSupport = "If the problem persists, contact support"
    public static let somethingWentWrong = "Something went wrong. \(tryAgain). \(contactSupport)."
    
    // MARK: - Store
    
    public static let productPurchased = "You have already bought this product."
    public static let unknownProductState = "We unable to fetch product information."
    public static let paymentInvalid = "One of the payment parameters was not recognized by the App Store."
    public static let productNotAvailable = "The product is not available in the current storefront."
    public static let notAuthorized = "You are not authorized to make payments"
    public static let purchasesMayBeRestricted = "In-App Purchases may be restricted on your device"
    public static let cannotMakePayments = "\(notAuthorized). \(purchasesMayBeRestricted)."
    public static let storeCommunicationError = "There was an error communicating with the iTunes Store."
    public static let restored = "All transactions have been successfully restored."
    public static let nothingToRestore = "There are no transactions that could be restored."
    public static let restorationFailed = "Some products have not been restored. \(tryAgain). \(contactSupport)."
    
    // MARK: - Utilities
    
    public static let noPermissions = "We did not receive required permissions"
    public static let manualPermission = "You can change your preferences at any time. To do that, you should manually grant permissions for the app from Settings"
    public static let notificationPermissionsRequired = "\(noPermissions) to send notifications. \(manualPermission)."
    public static let photoLibraryPermissionsRequired = "\(noPermissions) to access Photo Library. \(manualPermission)."
    public static let cameraLibraryPermissionsRequired = "\(noPermissions) to access Camera. \(manualPermission)."
    public static let cannotHandleURL = "Received URL cannot be handled."
    public static let noMatchingURLRules = "No matching rules found."
}
