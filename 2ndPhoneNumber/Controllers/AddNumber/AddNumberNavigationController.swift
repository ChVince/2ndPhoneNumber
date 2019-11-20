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
        self.delegate = self

        show(CountryListViewController(), sender: nil)
    }


}
