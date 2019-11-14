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
        let layout: UICollectionViewLayout = UICollectionViewFlowLayout()

        let phoneViewController = PhoneViewController(collectionViewLayout: layout)
        phoneViewController.accountViewModel = accountViewModel

        self.viewControllers = [phoneViewController]
    }
}
