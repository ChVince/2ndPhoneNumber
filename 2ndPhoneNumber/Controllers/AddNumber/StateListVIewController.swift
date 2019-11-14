//
//  StateListVIewController.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 29/09/2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

class StateListViewCell: UITableViewCell {
    var data: State? {
        didSet {
            setupCellLayout()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
    }

    func setupCellLayout() {
        guard let unwrappedStateData = data else {
            return
        }

        setupTextLabel(
            stateName: unwrappedStateData.name,
            stateCode: unwrappedStateData.stateCode
        )
    }


    func setupTextLabel(stateName: String, stateCode: String) {
        textLabel?.text = stateName + " (" + stateCode + ")"
        textLabel?.font = UIFont.systemFont(ofSize: 16)
    }

}

class StateListViewController: AddNumberViewController, UISearchResultsUpdating {
    let reusableCellId = "stateCellId"
    let setupNumberViewModel = StateListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.register(StateListViewCell.self, forCellReuseIdentifier: reusableCellId)
        self.navigationItem.title = setupNumberViewModel.ancestor?.name
        self.searchController.searchBar.placeholder = NSLocalizedString("label.state.search", comment: "")
        searchController.searchResultsUpdater = self

        setupNumberViewModel.fetch(params: ["countryCode": setupNumberViewModel.ancestor!.countryCode]){ [weak self] in
            self?.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = NumberListViewController()
        controller.setupNumberViewModel.ancestor = setupNumberViewModel.list[indexPath.row];
        navigationController?.pushViewController(controller, animated: true)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableCellId, for: indexPath) as! StateListViewCell

        if isFiltering {
            cell.data = setupNumberViewModel.filteredList[indexPath.row]
        } else {
            cell.data = setupNumberViewModel.list[indexPath.row]
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return setupNumberViewModel.filteredList.count
        } else {
            return setupNumberViewModel.list.count
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
           let searchBar = searchController.searchBar
           let searchText = searchBar.text!
           setupNumberViewModel.setFilteredList(filterBy: searchText)
           tableView.reloadData()
       }
}
