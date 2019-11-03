//
//  NumberListViewController.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 29/09/2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

class NumberListViewCell: UITableViewCell {
    var data: AreaNumber? {
        didSet {
            setupCellLayout()
        }
    }

    let requireAddressLabel: TagLabel = {
        let _requireAddressLabel = TagLabel()
        _requireAddressLabel.textAlignment = .center
        _requireAddressLabel.font = UIFont.systemFont(ofSize: 10)
        _requireAddressLabel.text = NSLocalizedString("label.number.address.required", comment: "")
        _requireAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        _requireAddressLabel.backgroundColor = .darkBlue
        _requireAddressLabel.textColor = .white
        return _requireAddressLabel
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
    }

    func setupCellLayout() {
        guard let unwrappedNumberData = data else {
            return
        }

        setupTextLabel(
            number: unwrappedNumberData.number
        )

        if unwrappedNumberData.isRequireAddress {
            setupRequireAddressLabel()
        }
    }

    func setupTextLabel(number: String) {
        textLabel?.text = number
        textLabel?.font = UIFont.systemFont(ofSize: 16)
    }

    func setupRequireAddressLabel() {
        contentView.addSubview(requireAddressLabel)
        NSLayoutConstraint.activate([
            requireAddressLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            requireAddressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
}

class NumberListViewController: AddNumberViewController, UISearchResultsUpdating {
    let reusableCellId = "numberCellId"
    let setupNumberViewModel = NumberListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.register(NumberListViewCell.self, forCellReuseIdentifier: reusableCellId)
        self.navigationItem.title = setupNumberViewModel.ancestor?.name
        self.searchController.searchBar.placeholder = NSLocalizedString("label.number.search", comment: "")
        searchController.searchResultsUpdater = self

        let params = getParams()
        setupNumberViewModel.fetch(params: params){ [weak self] in
            self?.tableView.reloadData()
        }
    }

    func getParams () -> [String: String] {
        let ancestor = setupNumberViewModel.ancestor
        if ((ancestor as? Country) != nil) {
            return ["countryCode": (ancestor as! Country).countryCode]
        } else {
            return [
                "countryCode": (ancestor as! State).countryCode,
                "stateCode": (ancestor as! State).stateCode
            ]
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(AddressViewController(), animated: true)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableCellId, for: indexPath) as! NumberListViewCell

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
