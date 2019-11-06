//
//  PhoneIndex.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 06.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

class PhoneNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout: UICollectionViewLayout = UICollectionViewFlowLayout()
        
        self.viewControllers = [PhoneViewController(collectionViewLayout: layout)]
        setupTabBarItem()
    }

    func setupTabBarItem() {
        self.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "phone"),
            selectedImage: UIImage(named: "phone-pressed")
        )
    }
}
