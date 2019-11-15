//
//  UserAccountNavigationController.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 03.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

class UserAccountNavigationController: UITabBarController {
    var accountViewModel: AccountViewModel = AccountViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewControllers = [
            //ConversationListNavigationController(),
            RecentCallsNavigationController(),
            ContactsNavigationController(),
            PhoneNavigationController(),
            ProfileNavigationController()
        ]

        setupTabBars()
    }

    func setupTabBars() {
        for viewController in self.viewControllers! {
            switch viewController {
            case is ConversationListNavigationController:
                let viewController = viewController as! ConversationListNavigationController
                viewController.accountViewModel = accountViewModel

                viewController.tabBarItem = UITabBarItem(
                    title: nil,
                    image: UIImage(named: "conversations"),
                    selectedImage: UIImage(named: "conversations-pressed")
                )
                break;
            case is RecentCallsNavigationController:
                let viewController = viewController as! RecentCallsNavigationController
                viewController.accountViewModel = accountViewModel

                viewController.tabBarItem = UITabBarItem(
                    title: nil,
                    image: UIImage(named: "calls"),
                    selectedImage: UIImage(named: "calls-pressed")
                )
                break;
            case is ContactsNavigationController:
                let viewController = viewController as! ContactsNavigationController
                viewController.accountViewModel = accountViewModel

                viewController.tabBarItem = UITabBarItem(
                    title: nil,
                    image: UIImage(named: "contacts"),
                    selectedImage: UIImage(named: "contacts-pressed")
                )
                break;
            case is PhoneNavigationController:
                let viewController = viewController as! PhoneNavigationController
                viewController.accountViewModel = accountViewModel

                viewController.tabBarItem = UITabBarItem(
                    title: nil,
                    image: UIImage(named: "phone"),
                    selectedImage: UIImage(named: "phone-pressed")
                )
                break;
            case is ProfileNavigationController:
                let viewController = viewController as! ProfileNavigationController
                viewController.accountViewModel = accountViewModel

                viewController.tabBarItem = UITabBarItem(
                    title: nil,
                    image: UIImage(named: "profile"),
                    selectedImage: UIImage(named: "profile-pressed")
                )
                break;
            default:
                return
            }
        }
    }
}
