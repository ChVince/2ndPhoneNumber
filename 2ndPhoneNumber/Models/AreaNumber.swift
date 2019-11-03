//
//  AreaNumber.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 14.10.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import Foundation

public class AreaNumber: Decodable {
    let number: String
    let isRequireAddress: Bool

    init(number: String, isRequireAddress: Bool) {
        self.number = number
        self.isRequireAddress = isRequireAddress
    }
}
