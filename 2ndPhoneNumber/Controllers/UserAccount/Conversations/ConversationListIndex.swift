//
//  index.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 03.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

class ConversationListNavigationController: UINavigationController {
    var accountViewModel: AccountViewModel! {
        didSet {
            setupViewControllers()
        }
    }

    func setupViewControllers() {
        let conversationListViewController = ConversationListViewController()
        conversationListViewController.accountViewModel = accountViewModel
        conversationListViewController.conversationsViewModel = ConversationViewModel(accountViewModel: accountViewModel)

        self.viewControllers = [conversationListViewController]
    }
}
