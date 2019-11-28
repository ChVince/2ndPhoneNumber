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
}
