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
    var countryData: Country? {
        didSet {
            availableTagsView.removeArrangedSubview(callsLabel)
            availableTagsView.removeArrangedSubview(smsLabel)
            setupCellLayout()
        }
    }

    let callsLabel: TagLable = {
        let _callsLabel = TagLable()
        _callsLabel.textAlignment = .center
        _callsLabel.font = UIFont.systemFont(ofSize: 10)
        _callsLabel.text = "Calls"
        _callsLabel.backgroundColor = .darkBlue
        _callsLabel.textColor = .white
        return _callsLabel
    }()

    let smsLabel: TagLable = {
        let _smsLabel = TagLable()
        _smsLabel.textAlignment = .center
        _smsLabel.font = UIFont.systemFont(ofSize: 10)
        _smsLabel.text = "SMS"
        _smsLabel.backgroundColor = .lightBlue
        _smsLabel.textColor = .white
        return _smsLabel
    }()

    let availableTagsView: UIStackView = {
        let _availableTagsView = UIStackView()
        _availableTagsView.spacing = 5
        _availableTagsView.translatesAutoresizingMaskIntoConstraints = false
        return _availableTagsView
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame = CGRect(x: 22, y: 12, width: imageView!.intrinsicContentSize.width, height:  imageView!.intrinsicContentSize.height)
        textLabel?.frame = CGRect(x: 60, y: 12, width: textLabel!.intrinsicContentSize.width, height:  textLabel!.intrinsicContentSize.height)
    }

    func setupCellLayout() {
        guard let unwrappedCountryData = countryData else {
            return
        }
        setImageView(countryCode: unwrappedCountryData.countryCode)
        setupTextLabel(countryName: unwrappedCountryData.name)
        setupSubtitleLabel(countryData: unwrappedCountryData)
    }

    func setImageView(countryCode: String) {
        let flag = Flag(countryCode: countryCode)

        guard let unwrappedFlag = flag else {
            print("No flag for", countryCode)
            return
        }
        
        imageView?.image = unwrappedFlag.image(style: .none)
    }

    func setupTextLabel(countryName: String) {
        textLabel?.text = countryName
        textLabel?.font = UIFont.systemFont(ofSize: 16)
    }

    func setupSubtitleLabel(countryData: Country) {
        if countryData.isCallable {
            availableTagsView.addArrangedSubview(callsLabel)
        }

        if countryData.isSMSable {
            availableTagsView.addArrangedSubview(smsLabel)
        }

        contentView.addSubview(availableTagsView)
        NSLayoutConstraint.activate([
            availableTagsView.leadingAnchor.constraint(equalTo: textLabel!.leadingAnchor, constant: 0),
            availableTagsView.topAnchor.constraint(equalTo: textLabel!.bottomAnchor, constant: 5)
        ])
    }
}

class CountryListViewController: UITableViewController, UISearchResultsUpdating {
    var countryListViewModel: CountryListViewModel = {
        return CountryListViewModel()
    }()

    var filteredCountries: [Country] = []

    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }

    let searchController: UISearchController = {
        let _searchController = UISearchController(searchResultsController: nil)
        _searchController.searchBar.placeholder = "Search country"
        _searchController.obscuresBackgroundDuringPresentation = false
        return _searchController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView?.register(CountryListViewCell.self, forCellReuseIdentifier: "cellId")

        self.setupNavigationItem()
        self.setupFooterView()
        self.setupTableStyle()

        countryListViewModel.fetch{ [weak self] in
            self?.tableView.reloadData()
        }
    }

    func setupTableStyle() {
        tableView.separatorInset = UIEdgeInsets(top: 11, left: 17, bottom: 11, right: 17)
        tableView.rowHeight = 65
    }

    func setupFooterView() {
        self.tableView.tableFooterView = UIView()
    }

    func setupNavigationItem() {
        definesPresentationContext = true
        searchController.searchResultsUpdater = self

        self.navigationItem.title = "Select country"
        self.navigationItem.searchController = searchController
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.countryListViewModel.getCountryList().count
        if isFiltering {
           return filteredCountries.count
         }
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! CountryListViewCell

        if isFiltering {
            cell.countryData = filteredCountries[indexPath.row]
        } else {
            cell.countryData = countryListViewModel.getCountryAt(index: indexPath.row)
        }

        return cell
    }

    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let searchText = searchBar.text!
        let countries = self.countryListViewModel.getCountryList()

        filteredCountries = countries.filter { (country: Country) -> Bool in
            return country.name.lowercased().contains(searchText.lowercased())
        }

        tableView.reloadData()
    }
}
