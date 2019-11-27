//
//  PhoneViewModel.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 27.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit


class PhoneViewModel {
    var accountViewModel: AccountViewModel

    init(accountViewModel: AccountViewModel) {
        self.accountViewModel = accountViewModel
    }

    func getPhoneDigits() -> [String] {
        return ["1", "2", "3", "4", "5", "6", "7", "8", "9", "*", "0", "#"]
    }

    func getPhoneLetters() -> [String] {
        return ["", "A B C", "D E F", "G H I", "J K L", "M N O", "P Q R S", "T U V", "W X Y Z", "", "+", ""]
    }

    func callByNumber(number: String) {
        if let url = URL(string: "https://google.com"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
