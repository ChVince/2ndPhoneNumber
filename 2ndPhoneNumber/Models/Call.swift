//
//  Call.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 03.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import Foundation

enum CallStatus {
    case MISSED
    case OUTGOING
    case INCOMING
    case CANCELLED
}

struct Call {
    var contactId: String
    var date: Date
    var status: CallStatus
}
