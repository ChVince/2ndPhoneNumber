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
    var data: Country? {
        didSet {
            setupCellLayout()
        }
    }

    let callsLabel: TagLabel = {
        let _callsLabel = TagLabel()
        _callsLabel.textAlignment = .center
        _callsLabel.font = UIFont.systemFont(ofSize: 10)
        _callsLabel.text = NSLocalizedString("label.calls", comment: "")
        _callsLabel.backgroundColor = .darkBlue
        _callsLabel.textColor = .white
        return _callsLabel
    }()

    let smsLabel: TagLabel = {
        let _smsLabel = TagLabel()
        _smsLabel.textAlignment = .center
        _smsLabel.font = UIFont.systemFont(ofSize: 10)
        _smsLabel.text = NSLocalizedString("label.sms", comment: "")
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
        guard let unwrappedCountryData = data else {
            return
        }
        setImageView(countryCode: unwrappedCountryData.countryCode)
        setupTextLabel(countryName: unwrappedCountryData.name)
        setupSubtitleLabel(data: unwrappedCountryData)
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

    func setupSubtitleLabel(data: Country) {
        availableTagsView.removeFromSuperview()
        callsLabel.removeFromSuperview()
        smsLabel.removeFromSuperview()

        if data.isCallable {
            availableTagsView.addArrangedSubview(callsLabel)
        }

        if data.isSMSable {
            availableTagsView.addArrangedSubview(smsLabel)
        }

        contentView.addSubview(availableTagsView)
        NSLayoutConstraint.activate([
            availableTagsView.leadingAnchor.constraint(equalTo: textLabel!.leadingAnchor, constant: 0),
            availableTagsView.topAnchor.constraint(equalTo: textLabel!.bottomAnchor, constant: 5)
        ])
    }
}

class CountryListViewController: AddNumberViewController, UISearchResultsUpdating {
    let reusableCellId = "countryCellId"
    let setupNumberViewModel = CountryListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.register(CountryListViewCell.self, forCellReuseIdentifier: reusableCellId)

        self.navigationItem.title = NSLocalizedString("label.country.select", comment: "")
        self.searchController.searchBar.placeholder = NSLocalizedString("label.country.search", comment: "")
        searchController.searchResultsUpdater = self

        self.tableView.rowHeight = 65

        setupNumberViewModel.fetch{ [weak self] in
            self?.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = setupNumberViewModel.list[indexPath.row];


        //TODO how divide?
        if data.hasStates {
            let controller = StateListViewController()
            controller.setupNumberViewModel.ancestor = data
            navigationController?.pushViewController(controller, animated: true)
        } else {
            let controller = NumberListViewController()
            controller.setupNumberViewModel.ancestor = data
            navigationController?.pushViewController(controller, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return setupNumberViewModel.filteredList.count
        } else {
            return setupNumberViewModel.list.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: reusableCellId, for: indexPath) as! CountryListViewCell

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
