//
//  CountryListViewModel.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 14.10.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//


import UIKit

class CountryListViewModel: Filterable {
    var list: [Country] = []
    var filteredList: [Country] = []

    func setFilteredList(filterBy: String) {
        filteredList = list.filter{ (country: Country) -> Bool in
            return country.name.lowercased().starts(with:filterBy.lowercased())
        }
    }

    func fetch(completion: @escaping () -> Void) {
        let service = Services.GET_COUNTRIES
        DataManager.fetchData(url: service.url) { [weak self] (data) in
            do {
                self?.list = try JSONDecoder().decode([Country].self, from: data)
            } catch let error {
                print(error)
            }
            completion()
        }
    }
}

class StateListViewModel: Filterable {
    var list: [State] = []
    var filteredList: [State] = []

    var ancestor: Country?

    func setFilteredList(filterBy: String) {
        filteredList = list.filter{ (country: State) -> Bool in
            return country.name.lowercased().starts(with:filterBy.lowercased())
        }
    }

    func fetch(params: [String: String] = [:] ,completion: @escaping () -> Void) {
        var service = Services.GET_STATES
        service.params = params
        DataManager.fetchData(url: service.url) { [weak self] (data) in
            do {
                self?.list = try JSONDecoder().decode([State].self, from: data)
            } catch let error {
                print(error)
            }
            completion()
        }
    }
}

class NumberListViewModel: Filterable {
    var list: [AreaNumber] = []
    var filteredList: [AreaNumber] = []

    var ancestor: NamedAreaProtocol?

    func setFilteredList(filterBy: String) {
        filteredList = list.filter{ (country: AreaNumber) -> Bool in
            return country.number.lowercased().starts(with:filterBy.lowercased())
        }
    }

    func fetch(params: [String: String] = [:], completion: @escaping () -> Void) {
        var service: Service
        if ((ancestor as? Country) != nil) {
            service = Services.GET_COUNTRY_NUMBERS
        } else {
            service = Services.GET_STATE_NUMBERS
        }

        service.params = params

        DataManager.fetchData(url: service.url) { [weak self] (data) in
            do {
                self?.list = try JSONDecoder().decode([AreaNumber].self, from: data)
            } catch let error {
                print(error)
            }
            completion()
        }
    }
}
