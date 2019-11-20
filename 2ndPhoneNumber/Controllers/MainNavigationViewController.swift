//
//  MainNavigationViewController.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 19.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

class MainNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let user = false// Get from Device Storage
        if user {
            perform(#selector(showUserAccountView), with: nil, afterDelay: 0.01)
        } else {
            perform(#selector(showWelcomeScreenController), with: nil, afterDelay: 0.01)
        }
    }

    @objc func showUserAccountView() {
        let userAccountNavigationController = UserAccountNavigationController()
        userAccountNavigationController.modalPresentationStyle = .overFullScreen
        present(userAccountNavigationController, animated: false)
    }

    @objc func showWelcomeScreenController() {
        let welcomeScreenController = WelcomeScreenController()
        welcomeScreenController.modalPresentationStyle = .overFullScreen
        present(welcomeScreenController, animated: false)
    }

}
