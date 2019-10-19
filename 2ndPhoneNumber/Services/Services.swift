//
//  Services.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 15.10.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import Foundation
private let api = "http://localhost:8000"

enum RequestType {
    case GET
    case POST
    case PUT
    case DELETE
}

struct Service {
    let url: URL?
    let type: RequestType

    init(endpoint: String, type: RequestType) {
        self.url = URL(string: api + endpoint)
        self.type = type
    }
}

enum Services {
    static let GET_COUNTRIES = Service(endpoint: "/countries", type: .GET)
}
