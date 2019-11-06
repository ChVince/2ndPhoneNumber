//
//  index.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 03.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

class ConversationListNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = [ConversationListViewController()]
        setupTabBarItem()
    }

    func setupTabBarItem() {
        self.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "conversations"),
            selectedImage: UIImage(named: "conversations-pressed")
        )
    }
}
