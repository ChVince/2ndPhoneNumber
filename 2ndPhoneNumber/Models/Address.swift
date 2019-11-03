//
//  Address.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 03.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import Foundation


struct Address {
    var customerName: String
    var street: String
    var city: String
    var country: String
    var state: String
    var postcode: String

    init() {
        self.customerName = ""
        self.street = ""
        self.city = ""
        self.country = ""
        self.state = ""
        self.postcode = ""
    }

    init(customerName: String, street: String, city: String, country: String, state: String, postcode: String) {
        self.customerName = customerName
        self.street = street
        self.city = city
        self.country = country
        self.state = state
        self.postcode = postcode
    }
}
