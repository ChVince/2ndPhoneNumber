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
    var message: Message

    init(conversation: Conversation) {
        self.conversation = conversation
        self.message = Message(message: "", author: .USER)
    }

    func getMessageList() -> [Message] {
        return self.conversation.messageList!
    }

    func setMessageText(text: String) {
        message.message = text
    }
    
    //### Not Implemented
    func sendMessage(completion: @escaping () -> Void) {
        message.date = Date()
        completion()
        /*
         let service = Services.POST_NUMBER_SETUP
         DataManager.fetchData(url: service.url) { [weak self] (data) in
         completion()
         }*/
    }
    
    
}
