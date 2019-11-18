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

    var dateLabelView: UILabel!
    var contactIconView: UIImageView!
    var contactNameLabel: UILabel!
    var messageLabel: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator

        setupGraphic()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame = CGRect(x: 20, y: 15, width: 40, height: 40)
        imageView?.makeRounded()
    }

    func setupGraphic() {
        dateLabelView = setupDateLabelView()
        contactIconView = setupContactIcon()
        contactNameLabel = setupContactName()
        messageLabel = setupMessageLabel()
    }

    func setupDateLabelView() -> UILabel {
        let dateLabel = UILabel()
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = .systemGray
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15)
        ])

        return dateLabel
    }

    func setupContactIcon() -> UIImageView {
        return imageView!
    }

    func setupContactName() -> UILabel {
        textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        textLabel?.textColor = .black

        return textLabel!
    }

    func setupMessageLabel() -> UILabel {
        detailTextLabel?.font = UIFont.systemFont(ofSize: 16)
        detailTextLabel?.textColor = .systemGray

        return detailTextLabel!
    }

    func setupCellData() {
        dateLabelView.text = conversationCellData.topMessage.getDate()
        contactIconView.image = UIImage(named: conversationCellData.contact.image)
        contactNameLabel.text = conversationCellData.contact.getContactName()
        messageLabel.text = conversationCellData.topMessage.message
    }
}

class ConversationListViewController: UITableViewController {
    var accountViewModel: AccountViewModel!

    override func loadView() {
        super.loadView()

        setupNavigationItem()
        setupTableView()
    }

    func setupNavigationItem() {
        self.navigationItem.title = NSLocalizedString("label.account.chats.title", comment: "")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "composeMessage"),
            style: .plain,
            target: self,
            action: #selector(onComposeMessageTap)
        )
    }

    func setupTableView() {
        tableView?.register(ConversationListViewCell.self, forCellReuseIdentifier: String(describing: ConversationListViewCell.self))
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = 65
    }

    @objc
    func onComposeMessageTap() {

    }
}

extension ConversationListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountViewModel.conversationCellDataList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ConversationListViewCell.self), for: indexPath) as! ConversationListViewCell
        cell.conversationCellData = accountViewModel.conversationCellDataList[indexPath.item]

        return cell
    }
}
