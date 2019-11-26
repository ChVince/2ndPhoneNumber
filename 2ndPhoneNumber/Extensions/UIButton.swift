//
//  UIButton.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 21.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

extension UIButton {
    func makeRounded() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}


