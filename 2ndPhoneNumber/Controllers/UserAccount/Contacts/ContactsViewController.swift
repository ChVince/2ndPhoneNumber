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
        textLabel?.font = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? UIFont.systemFont(ofSize: 14, weight: .bold) : UIFont.systemFont(ofSize: 16, weight: .bold)
        textLabel?.textColor = .black
    }

    func setupCellData() {
        imageView!.image = UIImage(named: contact.image!)
        textLabel!.text = contact.getContactName()
    }
}

class ContactsViewController: AccountDropdownNavigationController {
    var contactsViewModel: ContactsViewModel!

    var isSearchBarEmpty: Bool {
        return searchBar.text?.isEmpty ?? true
    }

    var isFiltering: Bool {
        return !isSearchBarEmpty
    }

    @UsesAutoLayout
    var searchBar = UISearchBar()

    @UsesAutoLayout
    var tableView = UITableView()

    override func loadView() {
        super.loadView()

        setupSearchController()
        setupTableView()
        setupNavigationItem()
        setupLayout()
    }

    func setupNavigationItem() {
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "add"),
            style: .plain,
            target: self,
            action: #selector(onAddContact)
        )
    }

    func setupSearchController() {
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = [
            NSLocalizedString("label.account.contacts.all", comment: ""),
            NSLocalizedString("label.account.contacts.phone", comment: "")
        ]
        searchBar.placeholder = NSLocalizedString("label.account.contacts.search", comment: "")

        searchBar.setScopeBarButtonTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.systemGray
        ], for: .normal)

        searchBar.setScopeBarButtonTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.systemBlue
        ], for: .selected)

        searchBar.backgroundImage = UIImage()
        searchBar.barTintColor = .white

        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 0.45)
        }

        if let btnCancel = searchBar.value(forKey: "cancelButton") as? UIButton {
            btnCancel.tintColor = .systemBlue
        }

        searchBar.delegate = self
        view.addSubview(searchBar)
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

    func setupLayout() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc func onAddContact() {
        let contactViewController = EditContactViewController()
        contactViewController.contactViewModel = ContactViewModel()

        navigationController?.pushViewController(contactViewController, animated: true)
    }
}

extension ContactsViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contactViewController = ReadContactViewController()
        let cell = tableView.cellForRow(at: indexPath) as! ContactViewCell

        contactViewController.contactViewModel = ContactViewModel(contact: cell.contact)

        tableView.deselectRow(at: indexPath, animated: false)
        navigationController?.pushViewController(contactViewController, animated: true)
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsViewModel.getContactList().count
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ContactViewCell.self), for: indexPath) as! ContactViewCell
        cell.contact = contactsViewModel.getContactList()[indexPath.item]

        return cell
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        if selectedScope == 0 {
            contactsViewModel.isFiltered = false
        }

        if selectedScope == 1 {
            contactsViewModel.isFiltered = true
        }

        tableView.reloadData()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)

        contactsViewModel.searchText = searchBar.text
        tableView.reloadData()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
         contactsViewModel.searchText = searchBar.text
         tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)

        contactsViewModel.searchText = searchBar.text
        tableView.reloadData()
    }
}
