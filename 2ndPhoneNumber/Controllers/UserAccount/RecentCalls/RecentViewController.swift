//
//  ContactViewController.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 13.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

class RecentCallCell: UITableViewCell {
    var delegate: ContactViewController!
    var contact: Contact! {
        didSet {
            setupCellData()
        }
    }

    @UsesAutoLayout
    var contactMessageIconView = UIButton(type: .custom)

    @UsesAutoLayout
    var contactCallIconView = UIButton(type: .custom)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupContactMessageIcon()
        setupContactCallIcon()
        setupContactNumberLabel()

        contactMessageIconView.addTarget(self, action: #selector(self.onMessageTouch(sender:)), for: .touchUpInside)
        contactCallIconView.addTarget(self, action: #selector(self.onCallTouch(sender:)), for: .touchUpInside)

        NSLayoutConstraint.activate([
            contactMessageIconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contactMessageIconView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])

        NSLayoutConstraint.activate([
            contactCallIconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contactCallIconView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60)
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setupContactMessageIcon() {
        let image = UIImage(named: "contactCall")
        contactMessageIconView.setImage(image, for: .normal)

        self.contentView.addSubview(contactMessageIconView)
    }

    func setupContactCallIcon() {
        let image = UIImage(named: "message")
        contactCallIconView.setImage(image, for: .normal)

        self.contentView.addSubview(contactCallIconView)
    }

    func setupContactNumberLabel() {
        textLabel?.font = .systemFont(ofSize: 18)
        textLabel?.textColor = .black
    }

    @objc func onCallTouch(sender: UIButton) {
        delegate.onCellCallTap(contact: contact)
    }

    @objc func onMessageTouch(sender: UIButton) {
        delegate.onCellMessageTap(contact: contact)
    }

    func setupCellData() {
        textLabel!.text = contact.number
    }
}

class RecentViewController: UIViewController {
    var contactsViewModel: ContactsViewModel! {
        didSet {
            setupViewData(contact: contactsViewModel.accountViewModel.contactList[0])
        }
    }

    @UsesAutoLayout
    var contactImageView = UIImageView()

    @UsesAutoLayout
    var contactImageLabelView = UILabel()

    @UsesAutoLayout
    var contactNumberListTable = UITableView()

    override func loadView() {
        super.loadView()

        setupContactImageView()
        setupContactImageLabelView()
        setupContactNumberListTable()

        setupNavigaitonItem()

        setupLayout()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            contactImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            contactImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            contactImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            contactImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            contactImageLabelView.topAnchor.constraint(equalTo: contactImageView.bottomAnchor, constant: 15),
            contactImageLabelView.widthAnchor.constraint(equalTo: view.widthAnchor),
            contactImageLabelView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    func setupNavigaitonItem() {
        self.navigationItem.title = NSLocalizedString("label.account.contact.title", comment: "")
    }

    func setupContactImageView() {
        contactImageView.frame = CGRect(x: 22, y: 8, width: 128, height: 128)
        contactImageView.makeRounded()

        view.addSubview(contactImageView)
    }

    func setupContactImageLabelView() {
        contactImageLabelView.font = .systemFont(ofSize: 16, weight: .bold)
        contactImageLabelView.textAlignment = .center

        view.addSubview(contactImageLabelView)
    }

    func setupContactNumberListTable() {
        contactNumberListTable.register(RecentCallCell.self, forCellReuseIdentifier: String(describing: RecentCallCell.self))
        contactNumberListTable.delegate = self
        contactNumberListTable.dataSource = self
        contactNumberListTable.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        contactNumberListTable.tableFooterView = UIView()
        contactNumberListTable.rowHeight = 56
        contactNumberListTable.allowsSelection = false

        view.addSubview(contactNumberListTable)
    }

    func setupViewData(contact: Contact) {
        contactImageView.image = UIImage(named: contact.image)
        contactImageLabelView.text = contact.getContactName()
    }
}

extension RecentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1// Should be equal to number count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RecentCallCell.self), for: indexPath) as! RecentCallCell

        return cell
    }

    func onCellCallTap(contact: Contact) {
        contactsViewModel.callTo(contact: contact)
    }

    func onCellMessageTap(contact: Contact) {
        contactsViewModel.sendMessageTo(contact: contact)
    }
}

