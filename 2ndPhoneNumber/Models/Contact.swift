//
//  Contact.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 04.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import Foundation

enum ContactType {
    case NUMBER
    case PHONE
}


struct Contact {
    var contactId: String?
    var name: String?
    var surname: String?
    var image: String?
    var number: String?
    var contactType: ContactType

    init(contactId: String, name: String, surname: String, image: String, number: String, contactType: ContactType) {
        self.contactId = contactId
        self.name = name
        self.surname = surname
        self.image = image
        self.number = number
        self.contactType = .NUMBER
    }

    init() {
        self.contactId = nil
        self.name = nil
        self.surname = nil
        self.image = nil
        self.number = nil
        self.contactType = .NUMBER
    }

    func getContactName() -> String {
        let contactName = NSLocalizedString("label.account.contact.title", comment: "")

        guard let name = self.name else {
            return contactName
        }

        guard let surname = self.surname else {
            return contactName
        }

        return "\(name) \(surname)" 
    }
}
