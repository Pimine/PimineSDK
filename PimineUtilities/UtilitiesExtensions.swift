//
//  UtilitiesExtensions.swift
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

import UIKit

public extension UIApplication {
    
    var keyWindow: UIWindow? {
        windows.filter { $0.isKeyWindow }.first
    }
    
    var topViewController: UIViewController? {
        guard let rootViewController = keyWindow?.rootViewController else { return nil }
        return topViewController(base: rootViewController)
    }
    
    func topViewController(base: UIViewController) -> UIViewController {
        // Navigation controller
        if
            let navigationController = base as? UINavigationController,
            let visibleController = navigationController.visibleViewController {
            return topViewController(base: visibleController)
        // TabBar controller
        } else if
            let tabBarController = base as? UITabBarController,
            let selectedController = tabBarController.selectedViewController {
            return topViewController(base: selectedController)
        // Default presented controller
        } else if let presented = base.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

extension String: LocalizedError {
    public var errorDescription: String? { self }
}
