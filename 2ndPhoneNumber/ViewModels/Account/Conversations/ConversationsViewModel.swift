//
//  ConversationViewModel.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 27.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import Foundation

class ConversationsViewModel {
    var accountViewModel: AccountViewModel

    init(accountViewModel: AccountViewModel) {
        self.accountViewModel = accountViewModel
    }

    func getConversation(conversationId: String) -> Conversation {
        var conversation = Conversation(conversationId: "test", contactId:"test")
        conversation.messageList = mockMessageList1
        return conversation
    }
}
