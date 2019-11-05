//
//  UserAccountNavigationController.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 03.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

class UserAccountNavigationController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let conversationListViewNavigationController = ConversationListNavigationController()
        let historyListViewNavigationController = HistoryListNavigationController()

        self.viewControllers = [conversationListViewNavigationController, historyListViewNavigationController]
        self.selectedViewController = conversationListViewNavigationController
    }
}
