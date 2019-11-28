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
    var isFiltered = false
    var searchText: String? = nil

    init(accountViewModel: AccountViewModel) {
        self.accountViewModel = accountViewModel
    }

    func getContactList() -> [Contact] {
        var list = accountViewModel.contactList

        if isFiltered {
            list = list.filter{ (contact: Contact) -> Bool in
                return contact.contactType == .PHONE
            }
        }

        if let searchText = self.searchText {
            list = list.filter{ (contact: Contact) -> Bool in
                return contact.getContactName().lowercased().starts(with: searchText.lowercased())
            }
        }

        return list
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
