//
//  TagLabel.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 17.10.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit


class TagLable: UILabel {
    var insets: UIEdgeInsets

    override init(frame: CGRect) {
        insets = UIEdgeInsets(top: 3, left: 6, bottom: 3, right: 6)
        super.init(frame: frame)

        self.layer.masksToBounds = true;
        self.layer.cornerRadius = 2;
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += self.insets.left + self.insets.right
        size.height += self.insets.top + self.insets.bottom
        return size
    }
}
