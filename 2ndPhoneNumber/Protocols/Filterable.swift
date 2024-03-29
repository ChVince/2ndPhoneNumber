//
//  Filterable.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 14.10.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

protocol Filterable {
    associatedtype T

    var list: [T] { get }
    var filteredList: [T] { get set }

    func setFilteredList(filterBy: String)
}
