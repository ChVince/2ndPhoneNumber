//
//  Date.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 27.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import Foundation


extension Date {
    func format() -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.doesRelativeDateFormatting = true

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"

        let time = "\(dateFormatter.string(from: self)), \(timeFormatter.string(from: self))"
        return time
    }
}
