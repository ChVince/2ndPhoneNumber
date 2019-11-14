//
//  UIImageView.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 13.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

extension UIImageView {
    func makeRounded() {
        self.layer.borderWidth = 0.1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
