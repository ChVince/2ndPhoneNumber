//
//  Filterable.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 14.10.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

protocol Filterable {
    func getFilteredList<T>(list: [T], filterBy: String) -> [T]
}
