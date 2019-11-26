//
//  HistoryListViewController.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 03.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

class ContactViewCell: UITableViewCell {
    var contact: Contact! {
        didSet {
            setupCellData()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        setupContactLabelView()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame = CGRect(x: 22, y: 8, width: 40, height: 40)
        textLabel?.frame = CGRect(x: 75, y: 20, width: textLabel!.intrinsicContentSize.width, height:  textLabel!.intrinsicContentSize.height)
        imageView?.makeRounded()
    }

    func setupContactLabelView() {
        textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        textLabel?.textColor = .black
    }

    func setupCellData() {
        imageView!.image = UIImage(named: contact.image)
        textLabel!.text = contact.getContactName()
    }
}

class ContactsViewController: AccountDropdownNavigationController {
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }

    var searchController = UISearchController(searchResultsController: nil)

    @UsesAutoLayout
    var tableView = UITableView()

    override func loadView() {
        super.loadView()

        setupSearchController()
        setupTableView()
        setupNavigationItem()

        setupLayout()
    }

    func setupSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.scopeButtonTitles = [
            NSLocalizedString("label.account.contacts.all", comment: ""),
            NSLocalizedString("label.account.contacts.phone", comment: "")
        ]
        searchController.searchBar.placeholder = NSLocalizedString("label.account.contacts.search", comment: "")
        searchController.searchResultsUpdater = self

        searchController.searchBar.setScopeBarButtonTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.systemGray
        ], for: .normal)

        searchController.searchBar.setScopeBarButtonTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.systemBlue
        ], for: .selected)
    }

    func setupTableView() {
        tableView.register(ContactViewCell.self, forCellReuseIdentifier: String(describing: ContactViewCell.self))
        tableView.separatorInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 56
        tableView.delegate = self
        tableView.dataSource = self

        view.addSubview(tableView)
    }

    func setupNavigationItem() {
        definesPresentationContext = true
        self.navigationItem.searchController = searchController
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ContactsViewController: UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contactViewController = ContactViewController()
        navigationController?.pushViewController(contactViewController, animated: true)
        contactViewController.accountViewModel = accountViewModel
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountViewModel.contactList.count
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ContactViewCell.self), for: indexPath) as! ContactViewCell
        cell.contact = accountViewModel.contactList[indexPath.item]

        return cell
    }

    func updateSearchResults(for searchController: UISearchController) {
        // TODO implement
    }
}
