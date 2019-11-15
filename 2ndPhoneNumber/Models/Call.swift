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

    func getDate() -> String {
        let formattedDate: String
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        let weekDay = dateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: date)]
        formattedDate = "\(weekDay), \(dateFormatter.string(from: date))"
        return formattedDate
    }
}
