//
//  ContactsViewModel.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 27.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

class ContactsViewModel {
    var accountViewModel: AccountViewModel

    init(accountViewModel: AccountViewModel) {
        self.accountViewModel = accountViewModel
    }

    func getContactList() -> [Contact]{
        return accountViewModel.contactList
    }

    func sendMessageTo(contact: Contact) {
        //TODO: Implement
    }

    func callTo(contact: Contact) {
        if let url = URL(string: "https://google.com"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }

}
