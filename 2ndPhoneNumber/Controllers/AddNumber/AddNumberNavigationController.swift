//
//  index.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 11.10.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

class AddNumberNavigationController: UINavigationController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = [WelcomeScreenController()]

        self.delegate = self
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.view.backgroundColor = .white
        if (navigationController.viewControllers.count > 1) {
            navigationController.setNavigationBarHidden(false, animated: true)
        } else {
            navigationController.setNavigationBarHidden(true, animated: true)
        }
    }

}
