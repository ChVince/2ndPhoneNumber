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

        }
    }
}

class ConversationListViewController: UITableViewController {
    var accountViewModel = AccountViewModel()
    let reusableCellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView?.register(ConversationListViewCell.self, forCellReuseIdentifier: reusableCellId)

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
