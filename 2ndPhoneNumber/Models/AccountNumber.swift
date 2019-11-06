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
    var isActive = false
    
    init(number: String, isRequireAddress: Bool, isActive: Bool) {
        super.init(number: number, isRequireAddress: isRequireAddress)
        self.isActive = isActive
    }

    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
