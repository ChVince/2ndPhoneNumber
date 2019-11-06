//
//  ContactsListIndex.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 06.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

class ContactsNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = [ContactsViewController()]
        setupTabBarItem()
    }

    func setupTabBarItem() {
        self.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "contacts"),
            selectedImage: UIImage(named: "contacts-pressed")
        )
    }
}
