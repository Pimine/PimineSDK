//
//  PMSubscriptionPriceFormatter.swift
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

final public class PMSubscriptionPriceFormatter {
    
    public static func string(
        from metadata: ProductInterfaceController.ProductState.PurchaseMetadata?,
        phrasingStyle: SubscriptionPriceFormatter.PhrasingStyle = .formal,
        unitCountStyle: SubscriptionPriceFormatter.UnitCountStyle = .numeric,
        freePriceReplacementText: String = "",
        locale: Locale = .current
    ) -> String? {
        guard
            let metadata = metadata,
            let subscriptionTerms = metadata.subscriptionTerms
        else { return nil }
        
        return string(
            from: metadata.price, duration: subscriptionTerms.duration,
            phrasingStyle: phrasingStyle,
            unitCountStyle: unitCountStyle,
            freePriceReplacementText: freePriceReplacementText,
            locale: locale
        )
    }
    
    public static func string(
        from purchase: Purchase,
        phrasingStyle: SubscriptionPriceFormatter.PhrasingStyle = .formal,
        unitCountStyle: SubscriptionPriceFormatter.UnitCountStyle = .numeric,
        freePriceReplacementText: String = "",
        locale: Locale = .current
    ) -> String? {
        
        guard let subscriptionTerms = purchase.subscriptionTerms else { return nil }
        
        return string(
            from: purchase.price, duration: subscriptionTerms.duration,
            phrasingStyle: phrasingStyle,
            unitCountStyle: unitCountStyle,
            freePriceReplacementText: freePriceReplacementText,
            locale: locale
        )
    }
    
    public static func string(
        from price: Price, duration: SubscriptionDuration,
        phrasingStyle: SubscriptionPriceFormatter.PhrasingStyle = .formal,
        unitCountStyle: SubscriptionPriceFormatter.UnitCountStyle = .numeric,
        freePriceReplacementText: String = "",
        locale: Locale = .current
    ) -> String {
        
        let formatter = SubscriptionPriceFormatter()
        formatter.phrasingStyle = phrasingStyle
        formatter.unitCountStyle = unitCountStyle
        formatter.freePriceReplacementText = freePriceReplacementText
        formatter.locale = locale
        
        return formatter.string(from: price, duration: duration)
    }
}
