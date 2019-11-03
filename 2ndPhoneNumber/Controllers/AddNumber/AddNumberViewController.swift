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
        let _searchController = UISearchController(searchResultsController: nil)
        _searchController.obscuresBackgroundDuringPresentation = false
        return _searchController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationItem()
        self.setupFooterView()
        self.setupTableStyle()
    }

    func setupTableStyle() {
        tableView.separatorInset = UIEdgeInsets(top: 11, left: 17, bottom: 11, right: 17)
    }

    func setupFooterView() {
        self.tableView.tableFooterView = UIView()
    }

    func setupNavigationItem() {
        definesPresentationContext = true
        self.navigationItem.searchController = searchController
    }
}
