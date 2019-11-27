//
//  ChatListViewController.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 03.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

class ConversationListViewCell: UITableViewCell {
    var conversationCellData: ConversationCellData! {
        didSet {
            setupCellData()
        }
    }

    @UsesAutoLayout
    var dateLabelView = UILabel()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator

        setupSubviews()
        setupLayout()
    }

    func setupSubviews() {
        setupDateLabelView()
        setupContactName()
        setupMessageLabel()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        imageView?.frame = CGRect(x: 22, y: 12, width: 40, height: 40)
        textLabel?.frame = CGRect(x: 75, y: 14, width: textLabel!.intrinsicContentSize.width, height:  textLabel!.intrinsicContentSize.height)
        detailTextLabel?.frame = CGRect(x: 75, y: 34, width: textLabel!.intrinsicContentSize.width, height:  textLabel!.intrinsicContentSize.height)

        imageView?.makeRounded()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            dateLabelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            dateLabelView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15)
        ])
    }

    func setupDateLabelView() {
        dateLabelView = UILabel()
        dateLabelView.font = UIFont.systemFont(ofSize: 12)
        dateLabelView.textColor = .systemGray
        contentView.addSubview(dateLabelView)
    }

    func setupContactName() {
        textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        textLabel?.textColor = .black
    }

    func setupMessageLabel() {
        detailTextLabel?.font = UIFont.systemFont(ofSize: 16)
        detailTextLabel?.textColor = .systemGray
    }

    func setupCellData() {
        dateLabelView.text = conversationCellData.topMessage.getDate()
        imageView!.image = UIImage(named: conversationCellData.contact.image)
        textLabel!.text = conversationCellData.contact.getContactName()
        detailTextLabel!.text = conversationCellData.topMessage.message
    }
}

class ConversationListViewController: AccountDropdownNavigationController {
    var conversationsViewModel: ConversationViewModel!

    @UsesAutoLayout
    var tableView = UITableView()

    override func loadView() {
        super.loadView()

        setupNavigationItem()
        setupTableView()

        setupLayout()
    }

    func setupNavigationItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "composeMessage"),
            style: .plain,
            target: self,
            action: #selector(onComposeMessageTap)
        )
    }

    func setupTableView() {
        tableView.register(ConversationListViewCell.self, forCellReuseIdentifier: String(describing: ConversationListViewCell.self))
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = 64
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        view.addSubview(tableView)
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc
    func onComposeMessageTap() {

    }

}

extension ConversationListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contactViewController = ContactViewController()
        navigationController?.pushViewController(contactViewController, animated: true)
        contactViewController.contactsViewModel = ContactsViewModel(accountViewModel: accountViewModel)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountViewModel.conversationCellDataList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ConversationListViewCell.self), for: indexPath) as! ConversationListViewCell
        cell.conversationCellData = accountViewModel.conversationCellDataList[indexPath.item]

        return cell
    }
}
