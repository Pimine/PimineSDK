//
//  SwiftyStore.Messages.swift
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
struct Messages {
    
    // MARK: - General
    
    static let error = "There was an error"
    
    static let tryAgain = "Please try again"
    static let contactSupport = "If the problem persists, contact support"
    static let somethingWentWrong = "Something went wrong. \(tryAgain). \(contactSupport)."
    
    // MARK: - Messages related to receipt verification
    
    static let wrongProductType = "\(error). Wrong product type."
    
    // MARK: - Messages related to purchases restoring
    
    static var restored = "All transactions have been successfully restored."
    static var nothingToRestore = "There are no transactions that could be restored."
    static var restoreFailed = "Restore Failed. \(tryAgain). \(contactSupport)."

}}
