//
//  index.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 03.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

class RecentCallsNavigationController: UINavigationController {
    var accountViewModel: AccountViewModel! {
        didSet {
            setupViewControllers()
        }
    }

    func setupViewControllers() {
        let recentCallsViewController = RecentCallsViewController()

        recentCallsViewController.accountViewModel = accountViewModel
        recentCallsViewController.recentCallsViewModel = RecentCallsViewModel(accountViewModel: accountViewModel)

        self.viewControllers = [recentCallsViewController]
    }
}
