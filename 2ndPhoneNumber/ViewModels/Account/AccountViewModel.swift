//
//  ChatLIstViewModel.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 04.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

let MockAccountNumbers = [
    AccountNumber(countryCode: "US", number: "+57575757575", isRequireAddress: false, isActive: true),
    AccountNumber(countryCode: "US", number: "+5757575757342345", isRequireAddress: false, isActive: false),
    AccountNumber(countryCode: "US", number: "+375 29 1744609", isRequireAddress: false, isActive: false)
]

var mockContactList = [
    Contact(contactId:"test", name: "Jack", surname: "Doe", image: "contactJack", number: "+57575757575", contactType: .NUMBER),
    Contact(contactId:"test", name: "Yelizar", surname: "Doe", image: "contactJack", number: "+57575757575", contactType: .NUMBER),
    Contact(contactId:"test", name: "Ihnat", surname: "Doe", image: "contactJack", number: "+57575757575", contactType: .PHONE),
]

var mockConversationList = [
    Conversation(conversationId: "test", contactId:"test"),
    Conversation(conversationId: "test2", contactId:"test2"),
]

var mockMessageList1 = [
    Message(date: Date.init(), message: "Hello My name is Yelizar how ola Are You? I actually glad to see upyt in my house because i am glad for dinner and supper and people not know how i am fat it'a always right", author: .USER),
    Message(date: Date.init(), message: "HOw are You?", author: .USER),
    Message(date: Date.init(), message: "Hi", author: .COLLOCUTOR),
    Message(date: Date.init(), message: "Good!", author: .COLLOCUTOR)
]

var mockMessageList2 = [
    Message(date: Date.init(), message: "who a u?", author: .USER),
    Message(date: Date.init(), message: "Luka))", author: .COLLOCUTOR)
]

var mockRecentsList = [
    Call(contactId:"test", date: Date(), status: .INCOMING),
    Call(contactId:"test", date: Date(), status: .MISSED),
    Call(contactId:"test", date: Date(), status: .MISSED),
    Call(contactId:"test", date: Date(), status: .INCOMING),
    Call(contactId:"test", date: Date(), status: .INCOMING),
]

struct ConversationCellData {
    var conversationId: String
    var contact: Contact
    var topMessage: Message
}

struct RecentCellData {
    var contact: Contact
    var call: Call
}

class AccountViewModel {
    var conversationCellDataList: [ConversationCellData] = []
    var recentsCellDataList: [RecentCellData] = []
    var accountNumbers: [AccountNumber]
    var activeAccountNumber: AccountNumber? {
        didSet {
            self.fetchActiveNumberData()
            self.refreshConversationCellDataList()
            self.refreshRecentsCellDataList()
        }
    }
    var contactList: [Contact] {
        get {
            return mockContactList
        }
    }

    init() {
        self.accountNumbers = MockAccountNumbers// load from disk
        self.activeAccountNumber = self.getActiveNumber()

        self.fetchActiveNumberData()
        self.refreshConversationCellDataList()
        self.refreshRecentsCellDataList()
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
            let conversationCellData = ConversationCellData(conversationId: conversation.conversationId, contact: contact!, topMessage: conversation.messageList![0])
            conversationCellDataList.append(conversationCellData)
        }

        self.conversationCellDataList = conversationCellDataList
    }

    func refreshRecentsCellDataList() {
           var recentsCellDataList: [RecentCellData] = []

           for recent in mockRecentsList {
               let contact = self.activeAccountNumber!.contactList?[0]
               let recentCellData = RecentCellData(contact: contact!, call: recent)
               recentsCellDataList.append(recentCellData)
           }

           self.recentsCellDataList = recentsCellDataList
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
