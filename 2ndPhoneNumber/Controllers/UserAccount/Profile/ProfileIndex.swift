//
//  ProfileIndex.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 06.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

class ProfileNavigationController: UINavigationController {
    var accountViewModel: AccountViewModel! {
        didSet {
            setupViewControllers()
        }
    }

    func setupViewControllers() {
        let profileViewController = ProfileViewController()
        profileViewController.accountViewModel = accountViewModel

        self.viewControllers = [profileViewController]
    }
}
