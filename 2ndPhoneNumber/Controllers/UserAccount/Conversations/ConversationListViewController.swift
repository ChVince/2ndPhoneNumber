//
//  ChatListViewController.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 03.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

class ConversationListViewCell: UITableViewCell {
    var data: ConversationCellData? {
        didSet {
            setupCellLayout()
        }
    }

    var dateLabel: UILabel = {
        var _dateLabel = UILabel()
        _dateLabel.font = UIFont.systemFont(ofSize: 12)
        _dateLabel.textColor = .systemGray
        _dateLabel.translatesAutoresizingMaskIntoConstraints = false
        return _dateLabel
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
        imageView?.frame = CGRect(x: 20, y: 15, width: 40, height: 40)
    }

    func setupCellLayout() {
        guard let unwrappedConversationData = data else {
            return
        }

        setUserIcon(cellData: unwrappedConversationData)
        setupDate(cellData: unwrappedConversationData)
        setupUserName(cellData: unwrappedConversationData)
        setupMessage(cellData: unwrappedConversationData)
    }

    func setUserIcon(cellData: ConversationCellData) {
        var image = UIImage(named: cellData.contact.image)
        imageView?.image = UIImage(named: cellData.contact.image)
    }

    func setupUserName(cellData: ConversationCellData) {
        //textLabel?.text = "\(cellData.contact.name) \(cellData.contact.surname)"
        //textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        //textLabel?.textColor = .black
    }

    func setupDate(cellData: ConversationCellData) {
        let dateFormatter = DateFormatter()
        let date = cellData.topMessage.date
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        let weekDay = dateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: date)]
        dateLabel.text = "\(weekDay), \(dateFormatter.string(from: date))"
        contentView.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15)
        ])
    }

    func setupMessage(cellData: ConversationCellData) {
        detailTextLabel?.text = cellData.topMessage.message
        detailTextLabel?.font = UIFont.systemFont(ofSize: 16)
        detailTextLabel?.textColor = .systemGray
    }
}

class ConversationListViewController: UITableViewController {
    var accountViewModel: AccountViewModel!
    let reusableCellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView?.register(ConversationListViewCell.self, forCellReuseIdentifier: reusableCellId)

        self.tableView.rowHeight = 65
        setupNavigationItem()
        setupFooterView()
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

    func setupFooterView() {
        self.tableView.tableFooterView = UIView()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableCellId, for: indexPath) as! ConversationListViewCell
        cell.data = accountViewModel.conversationCellDataList[indexPath.row]

        return cell
    }
}
