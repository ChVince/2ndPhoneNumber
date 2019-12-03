//
//  AccountNumber.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 03.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import Foundation

class AccountNumber: AreaNumber {
    var conversationList: [Conversation]?
    var contactList: [Contact]?
    var address: Address?
    var isActive = false
    
    init(countryCode: String, number: String, isRequireAddress: Bool, isActive: Bool) {
        super.init(countryCode: countryCode, number: number, isRequireAddress: isRequireAddress)
        self.isActive = isActive
    }

    init(number: AreaNumber) {
        super.init(countryCode: number.countryCode, number: number.number, isRequireAddress: number.isRequireAddress)
    }

    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
