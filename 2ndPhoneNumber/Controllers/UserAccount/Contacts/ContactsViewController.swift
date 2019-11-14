//
//  HistoryListViewController.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 03.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

class ContactViewCell: UITableViewCell {
    var contactImageView: UIImageView!
    var contactLabelView: UILabel!
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

        self.contactImageView = setupContactImageView()
        self.contactLabelView = setupContactLabelView()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame = CGRect(x: 22, y: 8, width: 40, height: 40)
        textLabel?.frame = CGRect(x: 75, y: 20, width: textLabel!.intrinsicContentSize.width, height:  textLabel!.intrinsicContentSize.height)
        self.imageView?.makeRounded()
    }

    func setupContactImageView() -> UIImageView {
        return imageView!
    }

    func setupContactLabelView() -> UILabel {
        textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        textLabel?.textColor = .black

        return textLabel!
    }

    func setupCellData() {
        contactImageView.image = UIImage(named: contact.image)
        contactLabelView.text = contact.getContactName()
    }
}

class ContactsViewController: UITableViewController, UISearchResultsUpdating {
    var accountViewModel: AccountViewModel!

    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }

    var searchController: UISearchController!

    override func loadView() {
        super.loadView()

        self.searchController = setupSearchController()
        setupTableView()
        setupNavigationItem()
    }

    func setupSearchController() -> UISearchController {
        let searchController = UISearchController(searchResultsController: nil)
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

        return searchController
    }
    func setupTableView() {
        tableView.register(ContactViewCell.self, forCellReuseIdentifier: String(describing: ContactViewCell.self))
        tableView.separatorInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 56
    }
    func setupNavigationItem() {
        definesPresentationContext = true
        self.navigationItem.title = NSLocalizedString("label.account.contacts.title", comment: "")
        self.navigationItem.searchController = searchController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ContactsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let contactViewController = ContactViewController()
           navigationController?.pushViewController(contactViewController, animated: true)
           contactViewController.accountViewModel = accountViewModel
       }

       override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return accountViewModel.contactList.count
       }

       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ContactViewCell.self), for: indexPath) as! ContactViewCell
           cell.contact = accountViewModel.contactList[indexPath.item]

           return cell
       }

       func updateSearchResults(for searchController: UISearchController) {
           // TODO implement
       }
}
