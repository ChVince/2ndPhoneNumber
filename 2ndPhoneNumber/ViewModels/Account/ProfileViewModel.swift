//
//  ProfileViewModel.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 27.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import Foundation


class ProfileViewModel {
    var accountViewModel: AccountViewModel

    init(accountViewModel: AccountViewModel) {
        self.accountViewModel = accountViewModel
    }

    func getAccountNumbers() -> [AccountNumber] {
        return accountViewModel.accountNumbers
    }
}
