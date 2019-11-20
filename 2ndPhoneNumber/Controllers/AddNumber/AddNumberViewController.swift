//
//  AddNumberViewController.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 19.10.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

class AddNumberViewController: UITableViewController {
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }

    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()

    override func loadView() {
        super.loadView()

        self.setupNavigationItem()
        self.setupTableView()
    }

    func setupTableView() {
        tableView.separatorInset = UIEdgeInsets(top: 11, left: 17, bottom: 11, right: 17)
        tableView.estimatedRowHeight = 0
        self.tableView.tableFooterView = UIView()
    }

    func setupNavigationItem() {
        definesPresentationContext = true
        self.navigationItem.searchController = searchController
    }
}
