//
//  HistoryListViewController.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 03.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

class ContactsViewCell: UITableViewCell {
    var data: Message? {
        didSet {

        }
    }
}

class ContactsViewController: UITableViewController {
    let segemntControlview: UISegmentedControl = {
        return UISegmentedControl(items: [
            NSLocalizedString("label.account.contacts.all", comment: ""),
            NSLocalizedString("label.account.contacts.phone", comment: "")
        ])
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupFooterView()
    }

    func setupFooterView() {
        self.tableView.tableFooterView = UIView()
    }

    func setupNavigationItem() {
        self.navigationItem.title = NSLocalizedString("label.account.contacts.title", comment: "")
    }
}

extension ContactsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}
