//
//  UIRoundedImage.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 29.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

class UIRoundedButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()

        let radius: CGFloat = self.frame.height / 2.0
        self.layer.cornerRadius = radius
    }
}
