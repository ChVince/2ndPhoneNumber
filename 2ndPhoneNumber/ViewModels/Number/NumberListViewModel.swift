//
//  NumberListViewModel.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 29.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import Foundation

class NumberListViewModel: Filterable {
    var list: [AreaNumber] = []
    var filteredList: [AreaNumber] = []

    var ancestor: NamedAreaProtocol?

    init(ancestor: NamedAreaProtocol) {
        self.ancestor = ancestor
    }

    func setFilteredList(filterBy: String) {
        filteredList = list.filter{ (country: AreaNumber) -> Bool in
            return country.number.lowercased().starts(with:filterBy.lowercased())
        }
    }

    func fetch(completion: @escaping () -> Void) {
        var service: Service
        if ((ancestor as? Country) != nil) {
            service = Services.GET_COUNTRY_NUMBERS
        } else {
            service = Services.GET_STATE_NUMBERS
        }

        service.params = getParams()

        DataManager.fetchData(url: service.url) { [weak self] (data) in
            do {
                self?.list = try JSONDecoder().decode([AreaNumber].self, from: data)
            } catch let error {
                print(error)
            }
            completion()
        }
    }

    func getParams () -> [String: String] {
        let ancestor = self.ancestor
        if ((ancestor as? Country) != nil) {
            return ["countryCode": (ancestor as! Country).countryCode]
        } else {
            return [
                "countryCode": (ancestor as! State).countryCode,
                "stateCode": (ancestor as! State).stateCode
            ]
        }
    }
}
