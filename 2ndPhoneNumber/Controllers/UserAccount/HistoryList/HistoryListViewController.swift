//
//  HistoryListViewController.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 03.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

class HistoryListViewCell: UITableViewCell {
    var data: Message? {
        didSet {

        }
    }
}

class HistoryListViewController: UITableViewController {
    let segemntControlview: UISegmentedControl = {
        return UISegmentedControl(items: [
            NSLocalizedString("label.account.history.all", comment: ""),
            NSLocalizedString("label.account.history.missed", comment: "")
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
        self.navigationItem.title = NSLocalizedString("label.account.history.title", comment: "")
    }
}

extension HistoryListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}
