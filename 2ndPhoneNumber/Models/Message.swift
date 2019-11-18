//
//  Message.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 04.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import Foundation

enum Author {
    case USER
    case COLLOCUTOR
}

struct Message {
    var date: Date
    var message: String
    var author: Author

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
