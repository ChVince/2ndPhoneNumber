//
//  NumberListViewController.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 29/09/2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

class NumberListViewCell: UITableViewCell {
    var data: AreaNumber! {
        didSet {
            setupCellData()
        }
    }

    var requireAddressLabel: TagLabel!
    var numberLabel: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator

        setupCellLayout()
    }

    func setupCellLayout() {
        numberLabel = setupNumberLabel()
        requireAddressLabel = setupRequireAddressLabel()
    }

    func setupNumberLabel() -> UILabel {
        textLabel?.font = UIFont.systemFont(ofSize: 16)
        return textLabel!
    }

    func setupRequireAddressLabel() -> TagLabel {
        let requireAddressLabel = TagLabel()
        requireAddressLabel.textAlignment = .center
        requireAddressLabel.font = UIFont.systemFont(ofSize: 10)
        requireAddressLabel.text = NSLocalizedString("label.number.address.required", comment: "")
        requireAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        requireAddressLabel.backgroundColor = .darkBlue
        requireAddressLabel.textColor = .white
        requireAddressLabel.isHidden = true

        contentView.addSubview(requireAddressLabel)
        NSLayoutConstraint.activate([
            requireAddressLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            requireAddressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])

        return requireAddressLabel
    }

    func setupCellData() {
        numberLabel?.text = data.number

        if data.isRequireAddress {
            requireAddressLabel.isHidden = false
        }
    }

}

class NumberListViewController: AddNumberViewController, UISearchResultsUpdating, ModalHandler {
    var setupNumberViewModel: NumberListViewModel!
    var numberViewModel: NumberViewModel!

    override func loadView() {
        super.loadView()

        setupNavigationItem()
        setupTableView()

        setupNumberViewModel.fetch(){ [weak self] in
            self?.tableView.reloadData()
        }
    }

    func setupSearchController() {
        self.searchController.searchBar.placeholder = NSLocalizedString("label.number.search", comment: "")
        searchController.searchResultsUpdater = self
    }

    override func setupNavigationItem() {
        super.setupNavigationItem()
        self.navigationItem.title = setupNumberViewModel.ancestor?.name
    }

    override func setupTableView() {
        super.setupTableView()
        
        tableView?.register(NumberListViewCell.self, forCellReuseIdentifier: String(describing: NumberListViewCell.self))
    }
}

extension NumberListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cell = tableView.cellForRow(at: indexPath) as! NumberListViewCell
        let areaNumber = cell.data

        numberViewModel = NumberViewModel(number: areaNumber!)

        let isUserInitialized = UserDefaults.standard.bool(forKey: String(describing: AppPropertyList.isUserInitialized))

        if isUserInitialized && areaNumber!.isRequireAddress {
            let addressViewController = AddressViewController()
            addressViewController.numberViewModel = numberViewModel

            navigationController?.pushViewController(AddressViewController(), animated: true)
        } else if isUserInitialized {
            numberViewModel.setupNumber { [weak self] in
                self!.dismiss(animated: true) {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "number-added"), object: nil)
                }
            }
        } else {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = .horizontal

            let subscribeViewController = SubscribeViewController(collectionViewLayout: flowLayout)
            subscribeViewController.delegate = self
            subscribeViewController.modalPresentationStyle = .overFullScreen

            present(subscribeViewController, animated: true)

        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NumberListViewCell.self), for: indexPath) as! NumberListViewCell

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

    func modalDismissed() {
        if numberViewModel.number.isRequireAddress {
            let addressViewController = AddressViewController()
            addressViewController.numberViewModel = numberViewModel

            navigationController?.pushViewController(addressViewController, animated: true)
        } else {
            numberViewModel.setupNumber { [weak self] in
                self!.dismiss(animated: true) {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "number-added"), object: nil)
                }
            }
        }
    }

}
