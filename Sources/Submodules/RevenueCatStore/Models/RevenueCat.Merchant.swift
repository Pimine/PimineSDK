//
//  RCSMerchant.swift
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

import Purchases

extension RevenueCat {
final public class Merchant {
    
    // MARK: - Properties
    
    public weak var delegate: RCMerchantDelegate?
    
    // MARK: - Setup
    
    public func setup() {
        setupObservers()
        updatePurchaserInfo()
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification, object: nil
        )
    }
    
    // MARK: - Public API
    
    public func updatePurchaserInfo() {
        Purchases.shared.purchaserInfo { (purchaserInfo, error) in
            if let error = error {
                self.handleError(error)
                return
            }
            guard let purchaserInfo = purchaserInfo else { return }
            self.delegate?.merchant(self, didRecieve: purchaserInfo)
        }
    }
    
    // MARK: - Helpers
    
    private func handleError(_ error: Error) {
        PMAlert.show(error: error)
    }
    
    // MARK: - Observers
    
    @objc private func willEnterForeground() {
        updatePurchaserInfo()
    }
}}
