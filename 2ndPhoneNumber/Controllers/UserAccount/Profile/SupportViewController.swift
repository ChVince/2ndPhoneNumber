//
//  SupportViewController.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 12.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit
import SafariServices

class SupportViewController: SFSafariViewController, SFSafariViewControllerDelegate {
    override func viewDidLoad() {
        self.delegate = self
    }
}
