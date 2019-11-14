//
//  ContactViewController.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 13.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

class ContactNumberCell: UITableViewCell {
    var accountViewModel: AccountViewModel!
    var contact: Contact! {
        didSet {
            setupCellData()
        }
    }
    var contactMessageIconView: UIButton!
    var contactCallIconView: UIButton!
    var contactNumberLabelView: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupGraphic()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupGraphic() {
        self.contactMessageIconView = setupContactMessageIcon()
        self.contactCallIconView = setupContactCallIcon()
        self.contactNumberLabelView = setupContactNumberLabel()
        contactMessageIconView.addTarget(self, action: #selector(self.onMessageTouch(sender:)), for: .touchUpInside)
        contactCallIconView.addTarget(self, action: #selector(self.onCallTouch(sender:)), for: .touchUpInside)
    }

    func setupContactMessageIcon() -> UIButton {
        let setupContactMessageIcon = UIButton(type: .custom)
        let image = UIImage(named: "call")
        setupContactMessageIcon.setImage(image, for: .normal)
        setupContactMessageIcon.translatesAutoresizingMaskIntoConstraints = false

        self.contentView.addSubview(setupContactMessageIcon)
        NSLayoutConstraint.activate([
            setupContactMessageIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            setupContactMessageIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])

        return setupContactMessageIcon
    }

    func setupContactCallIcon() -> UIButton {
        let setupContactCallIcon = UIButton(type: .custom)
        let image = UIImage(named: "message")
        setupContactCallIcon.setImage(image, for: .normal)
        setupContactCallIcon.translatesAutoresizingMaskIntoConstraints = false

        self.contentView.addSubview(setupContactCallIcon)
        NSLayoutConstraint.activate([
            setupContactCallIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            setupContactCallIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60)
        ])

        return setupContactCallIcon
    }

    func setupContactNumberLabel() -> UILabel {
        textLabel?.font = .systemFont(ofSize: 18)
        textLabel?.textColor = .black

        return textLabel!
    }

    @objc func onCallTouch(sender: UIButton) {
        accountViewModel.callTo(contact: contact)
    }

    @objc func onMessageTouch(sender: UIButton) {
        accountViewModel.sendMessageTo(contact: contact)
    }

    func setupCellData() {
        contactNumberLabelView.text = contact.number
    }
}


class ContactViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var accountViewModel: AccountViewModel!

    var contactImageView: UIImageView!
    var contactImageLabelView: UILabel!
    var contactNumberListTable: UITableView!

    override func loadView() {
        super.loadView()

        self.contactImageView = setupContactImageView()
        self.contactImageLabelView = setupContactImageLabelView()
        self.contactNumberListTable = setupContactNumberListTable()

        setupNavigaitonItem()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupViewData(contact: self.accountViewModel.contactList[0])
    }

    func setupNavigaitonItem() {

        /*let editLabel = NSLocalizedString("label.contact.edit", comment: "")
        let underLinedMutableString = NSMutableAttributedString(string: editLabel, attributes:[
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
         ])
         */

        self.navigationItem.title = NSLocalizedString("label.account.contact.title", comment: "")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: NSLocalizedString("label.contact.edit", comment: ""),
            style: UIBarButtonItem.Style.plain,
            target: self,
            action: #selector(self.onEditTouch(sender:))
        )
    }

    func setupContactImageView() -> UIImageView {
        let contactImageView = UIImageView()
        contactImageView.frame = CGRect(x: 22, y: 8, width: 128, height: 128)
        contactImageView.makeRounded()
        contactImageView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(contactImageView)
        NSLayoutConstraint.activate([
            contactImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            contactImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        return contactImageView
    }
    func setupContactImageLabelView() -> UILabel {
        let contactImageLabelView = UILabel()
        contactImageLabelView.font = .systemFont(ofSize: 16, weight: .bold)
        contactImageLabelView.translatesAutoresizingMaskIntoConstraints = false
        contactImageLabelView.textAlignment = .center

        view.addSubview(contactImageLabelView)
        NSLayoutConstraint.activate([
            contactImageLabelView.topAnchor.constraint(equalTo: contactImageView.bottomAnchor, constant: 15),
            contactImageLabelView.widthAnchor.constraint(equalTo: view.widthAnchor),
            contactImageLabelView.heightAnchor.constraint(equalToConstant: 20)
        ])

        return contactImageLabelView
    }
    func setupContactNumberListTable() -> UITableView {
        let tableView = UITableView()
        tableView.register(ContactNumberCell.self, forCellReuseIdentifier: String(describing: ContactNumberCell.self))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 56
        tableView.allowsSelection = false

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: contactImageLabelView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        return tableView
    }

    func setupViewData(contact: Contact) {
        contactImageView.image = UIImage(named: contact.image)
        contactImageLabelView.text = contact.getContactName()
    }

    @objc func onEditTouch(sender: UIButton) {

    }
}

extension ContactViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1// Should be equal to number count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ContactNumberCell.self), for: indexPath) as! ContactNumberCell
        cell.contact = self.accountViewModel.contactList[0]
        cell.accountViewModel = accountViewModel

        return cell
    }
}
