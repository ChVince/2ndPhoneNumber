//
//  CountryListViewModel.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 14.10.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//


import UIKit



class CountryListViewModel: Filterable {
    var countryList: [Country]
    var filteredList: [Country]

    let reuseIdentifier = "CountryCell"

    init() {
        self.countryList = []
        self.filteredList = []
    }
    
    func setFilteredList(filterBy: String) {
        filteredList = countryList.filter{ (country: Country) -> Bool in
            return country.name.lowercased().starts(with:filterBy.lowercased())
        }
    }

    func fetch(completion: @escaping () -> Void) {
        DataManager.fetchData(service: Services.GET_COUNTRIES) { [weak self] (data) in
            do {
                self?.countryList = try JSONDecoder().decode([Country].self, from: data)
            } catch let error {
                print(error)
            }
            completion()
        }
    }
}
