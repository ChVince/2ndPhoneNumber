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
    var url: URL {
        get {
            return URL(string: api + self.endpoint)!
        }
    }
    let type: RequestType
    var endpoint: String

    var params: [String: String]? {
        didSet {
            injectParams()
        }
    }

    init(endpoint: String, type: RequestType) {
        self.endpoint = endpoint
        self.type = type
    }

    private mutating func injectParams () {
        for (name, value) in params! {
            endpoint = endpoint.replacingOccurrences(of: ":\(name)", with: value.lowercased())
        }
    }
}

enum Services {
    static let GET_COUNTRIES = Service(endpoint: "/countries.json", type: .GET)
    static let GET_STATES = Service(endpoint: "/countries/:countryCode/states", type: .GET)
    static let GET_COUNTRY_NUMBERS = Service(endpoint: "/countries/:countryCode/numbers", type: .GET)
    static let GET_STATE_NUMBERS = Service(endpoint: "/countries/:countryCode/:stateCode/numbers", type: .GET)
}
