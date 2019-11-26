//
//  NavigationBarDropdownDelegate.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 22.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

protocol NavigationBarDropdownDelegate: AnyObject {
    var isDropdownShown: Bool { get set }
    func toggleDropdown()
    func updateDropdownTitle()
}
