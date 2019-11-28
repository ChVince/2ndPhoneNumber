//
//  ContactViewController.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 13.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

class ReadContactNumberCell: UITableViewCell {
    var delegate: ReadContactViewController!
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


class ReadContactViewController: UIViewController {
    var contactViewModel: ContactViewModel! {
        didSet {
            setupViewData(contact: contactViewModel.contact)
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

    func setupNavigaitonItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: NSLocalizedString("label.contact.edit", comment: ""),
            style: UIBarButtonItem.Style.plain,
            target: self,
            action: #selector(self.onEditTouch(sender:))
        )
        self.navigationController?.navigationBar.isTranslucent = false
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
        contactNumberListTable.register(ReadContactNumberCell.self, forCellReuseIdentifier: String(describing: ReadContactNumberCell.self))
        contactNumberListTable.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        contactNumberListTable.delegate = self
        contactNumberListTable.dataSource = self

        contactNumberListTable.tableFooterView = UIView()
        contactNumberListTable.rowHeight = 64
        contactNumberListTable.allowsSelection = false

        view.addSubview(contactNumberListTable)
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            contactImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            contactImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            contactImageLabelView.topAnchor.constraint(equalTo: contactImageView.bottomAnchor, constant: 15),
            contactImageLabelView.widthAnchor.constraint(equalTo: view.widthAnchor),
            contactImageLabelView.heightAnchor.constraint(equalToConstant: 20)
        ])
        NSLayoutConstraint.activate([
            contactNumberListTable.topAnchor.constraint(equalTo: contactImageLabelView.bottomAnchor),
            contactNumberListTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contactNumberListTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contactNumberListTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setupViewData(contact: Contact) {
        contactImageView.image = UIImage(named: contact.image!)
        contactImageLabelView.text = contact.getContactName()
    }

    @objc func onEditTouch(sender: UIButton) {
        let contactViewController = EditContactViewController()
        contactViewController.contactViewModel = contactViewModel

        navigationController?.pushViewController(contactViewController, animated: true)
    }
}

extension ReadContactViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1// Should be equal to number count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ReadContactNumberCell.self), for: indexPath) as! ReadContactNumberCell
        cell.contact = contactViewModel.contact

        return cell
    }

    func onCellCallTap(contact: Contact) {
        contactViewModel.call()
    }

    func onCellMessageTap(contact: Contact) {
        contactViewModel.sendMessage()
    }
}
