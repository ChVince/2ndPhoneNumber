//
//  ConversationViewModel.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 27.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import Foundation

class ConversationViewModel {
    var conversation: Conversation

    init(conversation: Conversation) {
        self.conversation = conversation
    }

    func getMessageList() -> [Message] {
        return self.conversation.messageList!
    }
}
