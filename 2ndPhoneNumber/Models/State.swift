//
//  State.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 14.10.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import Foundation

public struct State: Decodable, NamedAreaProtocol {
    let name: String
    let stateCode: String
    let countryCode: String

    init(name: String, stateCode: String, countryCode: String) {
        self.name = name
        self.stateCode = stateCode
        self.countryCode = countryCode
    }
}
