//
//  ContactViewModel.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 27.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

enum ContactFieldKey: CaseIterable {
    case NAME
    case SURNAME
    case NUMBER

    var index: Self.AllCases.Index? {
        return Self.allCases.index { self == $0 }
    }
}

class ContactViewModel {
    var contact: Contact

    init(contact: Contact) {
        self.contact = contact
    }

    init() {
        self.contact = Contact()
        self.contact.contactType = .NUMBER
        self.contact.contactId = "\(Int.random(in: 1...100000))-\(Int.random(in: 1...100000))-\(Int.random(in: 1...100000))"
    }

    func sendMessage() {
         //TODO: Implement
     }

     func call() {
         if let url = URL(string: "https://google.com"), UIApplication.shared.canOpenURL(url) {
             UIApplication.shared.open(url)
         }
     }

    func setContactField(fieldKey: ContactFieldKey, value: String) {
        switch fieldKey {
        case .NAME:
            contact.name = value
            break;
        case .SURNAME:
            contact.surname = value
            break;
        case .NUMBER:
            contact.number = value
            break;
        }
    }
}
