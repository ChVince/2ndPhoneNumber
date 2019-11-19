//
//  CountryListView.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 29/09/2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit
import FlagKit

class CountryListViewCell: UITableViewCell {
    var data: Country! {
        didSet {
            setupCellData()
        }
    }

    var callsLabel: TagLabel!
    var smsLabel: TagLabel!
    var availableTagsView: UIStackView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator

        setupCellLayout()

    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame = CGRect(x: 22, y: 12, width: imageView!.intrinsicContentSize.width, height:  imageView!.intrinsicContentSize.height)
        textLabel?.frame = CGRect(x: 60, y: 12, width: textLabel!.intrinsicContentSize.width, height:  textLabel!.intrinsicContentSize.height)
        textLabel?.font = UIFont.systemFont(ofSize: 16)
    }

    func setupCallsLabel() -> TagLabel {
        let callsLabel = TagLabel()
        callsLabel.textAlignment = .center
        callsLabel.font = UIFont.systemFont(ofSize: 10)
        callsLabel.text = NSLocalizedString("label.calls", comment: "")
        callsLabel.backgroundColor = .darkBlue
        callsLabel.textColor = .white

        return callsLabel
    }

    func setupSMSLabel() -> TagLabel {
        let smsLabel = TagLabel()
        smsLabel.textAlignment = .center
        smsLabel.font = UIFont.systemFont(ofSize: 10)
        smsLabel.text = NSLocalizedString("label.sms", comment: "")
        smsLabel.backgroundColor = .lightBlue
        smsLabel.textColor = .white

        return smsLabel
    }

    func setupAvailableTagsView() -> UIStackView {
        let availableTagsView = UIStackView()
        availableTagsView.spacing = 5
        availableTagsView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(availableTagsView)
        NSLayoutConstraint.activate([
            availableTagsView.leadingAnchor.constraint(equalTo: textLabel!.leadingAnchor, constant: 0),
            availableTagsView.topAnchor.constraint(equalTo: textLabel!.bottomAnchor, constant: 5)
        ])

        return availableTagsView
    }

    func setupCellLayout() {
        callsLabel = setupCallsLabel()
        smsLabel = setupSMSLabel()
        availableTagsView = setupAvailableTagsView()
    }

    func setupCellData() {
        setImageViewData()
        setTextLabelData()
        setAvailableTagsData()
    }

    func setImageViewData() {
        let flag = Flag(countryCode: data.countryCode)
        imageView?.image = flag!.image(style: .none)
    }

    func setTextLabelData() {
        textLabel?.text = data.name
    }

    func setAvailableTagsData() {
        callsLabel.removeFromSuperview()
        smsLabel.removeFromSuperview()

        if data.isCallable {
            availableTagsView.addArrangedSubview(callsLabel)
        }

        if data.isSMSable {
            availableTagsView.addArrangedSubview(smsLabel)
        }
    }
}

class CountryListViewController: AddNumberViewController, UISearchResultsUpdating {
    var setupNumberViewModel: CountryListViewModel!

    override func loadView() {
        super.loadView()

        setupTableView()
        setupSearchController()
        setupNavigationItem()

        setupNumberViewModel.fetch{ [weak self] in
            self?.tableView.reloadData()
        }
    }

    override func setupTableView() {
        super.setupTableView()

        tableView?.register(CountryListViewCell.self, forCellReuseIdentifier: String(describing: CountryListViewCell.self))
        self.tableView.rowHeight = 65
    }

    override func setupNavigationItem() {
        super.setupNavigationItem()

        self.navigationItem.title = NSLocalizedString("label.country.select", comment: "")
    }

    func setupSearchController() {
        self.searchController.searchBar.placeholder = NSLocalizedString("label.country.search", comment: "")
        searchController.searchResultsUpdater = self
    }
}


extension CountryListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = setupNumberViewModel.list[indexPath.row];
        var controller: AddNumberViewController

        if data.hasStates {
            controller = StateListViewController()
            controller.viewTitle = data.name
        } else {
            controller = NumberListViewController()
            controller.viewTitle = data.name
        }

        navigationController?.pushViewController(controller, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return setupNumberViewModel.filteredList.count
        } else {
            return setupNumberViewModel.list.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CountryListViewCell.self), for: indexPath) as! CountryListViewCell

        if isFiltering {
            cell.data = setupNumberViewModel.filteredList[indexPath.row]
        } else {
            cell.data = setupNumberViewModel.list[indexPath.row]
        }

        return cell
    }

    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let searchText = searchBar.text!
        setupNumberViewModel.setFilteredList(filterBy: searchText)
        tableView.reloadData()
    }
}
