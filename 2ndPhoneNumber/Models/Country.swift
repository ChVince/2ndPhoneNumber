//
//  Country.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 14.10.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import Foundation

struct Country: Decodable {
    let countryCode: String
    let name: String
    let isCallable: Bool
    let isSMSable: Bool

    init(name: String, countryCode: String, isCallable: Bool, isSMSable: Bool) {
        self.name = name
        self.countryCode = countryCode
        self.isCallable = isCallable
        self.isSMSable = isSMSable
    }
}

