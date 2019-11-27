//
//  PhoneIndex.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 06.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

class PhoneNavigationController: UINavigationController {
    var accountViewModel: AccountViewModel! {
        didSet {
            setupViewControllers()
        }
    }

    func setupViewControllers() {
        let phoneViewController = PhoneViewController()
        phoneViewController.accountViewModel = accountViewModel
        phoneViewController.phoneViewModel = PhoneViewModel(accountViewModel: accountViewModel)

        self.viewControllers = [phoneViewController]
    }
}
