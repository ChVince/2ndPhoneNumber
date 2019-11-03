//
//  AddressViewModel.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 03.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

class AddressViewModel {
    let fieldLabelList: [String] = [
        NSLocalizedString("label.address.name", comment: ""),
        NSLocalizedString("label.address.street", comment: ""),
        NSLocalizedString("label.address.city", comment: ""),
        NSLocalizedString("label.address.state", comment: ""),
        NSLocalizedString("label.address.code", comment: ""),
        NSLocalizedString("label.address.country", comment: "")
    ]

    let addressFieldIdList: [String] = [
        "customerName",
        "street",
        "city",
        "state",
        "postalcode",
        "country"
    ]

    var address = Address()

    func setAddressField(fieldIdx: Int, value: String) {
        switch fieldIdx {
        case 0 :
            address.customerName = value
            break;
        case 1 :
            address.street = value
            break;
        case 2 :
            address.city = value
            break;
        case 3 :
            address.state = value
            break;
        case 4 :
            address.postcode = value
            break;
        case 5 :
            address.country = value
            break;
        default:
            return
        }
    }
}

