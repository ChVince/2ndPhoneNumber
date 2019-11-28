//
//  UICircleImageView.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 28.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

class UICircleImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()

        let radius: CGFloat = self.bounds.size.width / 2.0
        self.layer.cornerRadius = radius
    }
}
