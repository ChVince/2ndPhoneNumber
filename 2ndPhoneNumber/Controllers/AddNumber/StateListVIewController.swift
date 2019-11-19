//
//  StateListVIewController.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 29/09/2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

class StateListViewCell: UITableViewCell {
    var data: State! {
        didSet {
            setupCellData()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator

        setupCellLayout()
    }

    func setupCellLayout() {
        setupTextLabel()
    }

    func setupTextLabel() {
        textLabel?.font = UIFont.systemFont(ofSize: 16)
    }

    func setupCellData() {
        textLabel?.text = data.name + " (" + data.stateCode + ")"
    }

}

class StateListViewController: AddNumberViewController, UISearchResultsUpdating {
    let stateListViewModel = StateListViewModel()
    var viewTitle: String!

    override func loadView() {
        super.loadView()

        setupTableView()
        setupNavigationItem()
        setupSearchController()

        stateListViewModel.fetch(params: ["countryCode": stateListViewModel.ancestor!.countryCode]){ [weak self] in
            self?.tableView.reloadData()
        }
    }

    override func setupTableView() {
        super.setupTableView()

        tableView?.register(StateListViewCell.self, forCellReuseIdentifier: String(describing: StateListViewCell.self))
    }

    override func setupNavigationItem() {
        super.setupNavigationItem()

        self.navigationItem.title = viewTitle
    }

    func setupSearchController() {
        self.searchController.searchBar.placeholder = NSLocalizedString("label.state.search", comment: "")
        searchController.searchResultsUpdater = self
    }
}


extension StateListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = NumberListViewController()
        controller.viewTitle = stateListViewModel.list[indexPath.row].name

        navigationController?.pushViewController(controller, animated: true)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: StateListViewCell.self), for: indexPath) as! StateListViewCell

        if isFiltering {
            cell.data = stateListViewModel.filteredList[indexPath.row]
        } else {
            cell.data = stateListViewModel.list[indexPath.row]
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return stateListViewModel.filteredList.count
        } else {
            return stateListViewModel.list.count
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let searchText = searchBar.text!
        stateListViewModel.setFilteredList(filterBy: searchText)
        tableView.reloadData()
    }
}
