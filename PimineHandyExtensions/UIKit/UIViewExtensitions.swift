//
//  UIViewExtensitions.swift
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

#if(!os(watchOS))
import UIKit

// MARK: Protocol conformance

extension UIView: NameDescribable { }

// MARK: - Properties

public extension UIView {
    
    static var nib: UINib {
        UINib(nibName: typeName, bundle: nil)
    }
    
    /// http://www.openradar.me/25087688
    var isHiddenInStackView: Bool {
        get { return isHidden }
        set {
            if isHidden != newValue {
                isHidden = newValue
            }
        }
    }
}

// MARK: Initialization

public extension UIView {
    
    convenience init(backgroundColor: UIColor, frame: CGRect = .zero) {
        self.init(frame: frame)
        self.backgroundColor = backgroundColor
    }
    
    static func loadFromNib() -> Self? {
        nib.instantiate(withOwner: nil, options: nil).first as? Self
    }
}

// MARK: - Methods

public extension UIView {
    
    func addBorder(width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    
    @discardableResult
    @objc func onTouchUpInside(_ action: @escaping () -> Void) -> Self {
        isUserInteractionEnabled = true
        addTapGestureRecognizer(action: action)
        return self
    }
    
    fileprivate func addTapGestureRecognizer(action: @escaping () -> Void) {
        let sleeve = ClosureSleeve(action)
        objc_setAssociatedObject(
            self, UUID().uuidString, sleeve,
            objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN
        )
        let tapGestureRecognizer = UITapGestureRecognizer(target: sleeve, action: #selector(ClosureSleeve.invoke))
        addGestureRecognizer(tapGestureRecognizer)
    }
}

#endif
