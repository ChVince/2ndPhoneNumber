//
//  ChatLIstViewModel.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 04.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

let MockAccountNumbers = [
    AccountNumber(number: "+57575757575", isRequireAddress: false, isActive: true),
    AccountNumber(number: "+5757575757342345", isRequireAddress: false, isActive: false),
    AccountNumber(number: "+575757234235757342345", isRequireAddress: false, isActive: false)
]

var mockContactList = [
    Contact(contactId:"test", name: "Jack", surname: "Doe", image: "contactJack", number: "+57575757575")
]

var mockConversationList = [
    Conversation(contactId:"test"),
    Conversation(contactId:"test2"),
]

var mockMessageList1 = [
    Message(date: Date.init(), message: "Hello", author: .USER),
    Message(date: Date.init(), message: "HOw are You?", author: .USER),
    Message(date: Date.init(), message: "Hi", author: .COLLOCUTOR),
    Message(date: Date.init(), message: "Good!", author: .COLLOCUTOR)
]

var mockMessageList2 = [
    Message(date: Date.init(), message: "who a u?", author: .USER),
    Message(date: Date.init(), message: "Luka))", author: .COLLOCUTOR)
]

struct ConversationCellData {
    var contact: Contact
    var topMessage: Message
}

struct CallCellData {
    var contact: Contact
    var topCall: Message
}

class AccountViewModel {
    var conversationCellDataList: [ConversationCellData] = []
    var accountNumbers: [AccountNumber]
    var activeAccountNumber: AccountNumber? {
        didSet {
            self.fetchActiveNumberData()
            self.refreshConversationCellDataList()
        }
    }

    init() {
        self.accountNumbers = MockAccountNumbers// load from disk
        self.activeAccountNumber = self.getActiveNumber()

        self.fetchActiveNumberData()
        self.refreshConversationCellDataList()
    }

    func getActiveNumber() -> AccountNumber {
        var activeAccountNumber: AccountNumber
        guard self.activeAccountNumber != nil else {
            activeAccountNumber = accountNumbers.first(where: { $0.isActive })!
            return activeAccountNumber
        }

        return self.activeAccountNumber!
    }

    func setActiveNumber(number: String) {
        let nextActiveAccountNumber = accountNumbers.first(where: { $0.number == number })!

        activeAccountNumber!.isActive = false;
        nextActiveAccountNumber.isActive = true
        activeAccountNumber = nextActiveAccountNumber
    }

    func refreshConversationCellDataList() {
        let conversationList = self.activeAccountNumber!.conversationList
        var conversationCellDataList: [ConversationCellData] = []

        for conversation in conversationList! {
            let contact = self.activeAccountNumber!.contactList?[0]
            //self.activeAccountNumber!.contactList?.first(where: { $0.contactId == conversation.contactId })!
            let conversationCellData = ConversationCellData(contact: contact!, topMessage: conversation.messageList![0])
            conversationCellDataList.append(conversationCellData)
        }

        self.conversationCellDataList = conversationCellDataList
    }

    func fetchActiveNumberData() {
        fetchContacts()
        fetchActiveNumberConversations()
    }

    func fetchContacts() {
        self.activeAccountNumber!.contactList = mockContactList
    }

    func fetchActiveNumberConversations() {
        mockConversationList[0].messageList = mockMessageList1
        mockConversationList[1].messageList = mockMessageList2

        self.activeAccountNumber!.conversationList = mockConversationList
    }
}
