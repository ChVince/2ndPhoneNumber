//
//  ContactsListIndex.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 06.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

class ContactsNavigationController: UINavigationController {
    var accountViewModel: AccountViewModel! {
        didSet {
            setupViewControllers()
        }
    }

    func setupViewControllers() {
        let contactsViewController = ContactsViewController()
        contactsViewController.accountViewModel = accountViewModel
        contactsViewController.contactsViewModel = ContactsViewModel(accountViewModel: accountViewModel)

        self.viewControllers = [contactsViewController]
    }
}
