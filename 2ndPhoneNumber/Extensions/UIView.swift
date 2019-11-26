//
//  UIView.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 15.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

@propertyWrapper
public struct UsesAutoLayout<T: UIView> {
    public var wrappedValue: T {
        didSet {
            wrappedValue.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        wrappedValue.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension UIView {
    func alignXYCenter(byView: UIView? = nil) {
        let unwrappedByView = byView ?? superview!
        centerXAnchor.constraint(equalTo: unwrappedByView.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: unwrappedByView.centerYAnchor).isActive = true
    }

    func alignYCenter() {
        if let superview = superview {
            centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
        }
    }

    func alignXCenter() {
         if let superview = superview {
             centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
         }
     }

    func fillSuperview() {
        setAnchors(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor)
    }

    func anchorSize(to view: UIView) {
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }

    func setAnchors(top: NSLayoutYAxisAnchor? = nil, leading: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, trailing: NSLayoutXAxisAnchor? = nil, padding: UIEdgeInsets = .zero) {

        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }

        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }

        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }

        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
    }

    func setSize(width: CGFloat = .zero, height: CGFloat = .zero) {
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
