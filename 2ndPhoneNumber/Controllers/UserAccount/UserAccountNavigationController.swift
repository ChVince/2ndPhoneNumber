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

        self.viewControllers = [
            //ConversationListNavigationController(),
            //RecentCallsNavigationController(),
            //PhoneNavigationController(),
            //ContactsNavigationController(),
            ProfileNavigationController()
        ]

        setupTabBars()
    }

    func setupTabBars() {
        for viewController in self.viewControllers! {
            switch viewController {
            case is ConversationListNavigationController:
                viewController.tabBarItem = UITabBarItem(
                    title: nil,
                    image: UIImage(named: "conversations"),
                    selectedImage: UIImage(named: "conversations-pressed")
                )
                break;
            case is RecentCallsNavigationController:
                viewController.tabBarItem = UITabBarItem(
                    title: nil,
                    image: UIImage(named: "calls"),
                    selectedImage: UIImage(named: "calls-pressed")
                )
                break;
            case is PhoneNavigationController:
                viewController.tabBarItem = UITabBarItem(
                    title: nil,
                    image: UIImage(named: "phone"),
                    selectedImage: UIImage(named: "phone-pressed")
                )
                break;
            case is ContactsNavigationController:
                viewController.tabBarItem = UITabBarItem(
                    title: nil,
                    image: UIImage(named: "contacts"),
                    selectedImage: UIImage(named: "contacts-pressed")
                )
                break;
            case is ProfileNavigationController:
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
