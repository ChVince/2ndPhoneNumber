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

    let reuseIdentifier = "CountryCell"

    init() {
        self.countryList = []
    }

    func getFilteredList<Country>(list: [Country], filterBy: String) -> [Country] {
        list.filter({ (country: Country) -> Bool in
            print("iterate over")
            return true;
        })
    }

    func getCountryAt(index: Int) -> Country {
        return self.countryList[index]
    }

    func getCountryList() -> [Country] {
        return self.countryList;
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
