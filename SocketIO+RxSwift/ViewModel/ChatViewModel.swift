//
//  ChatViewModel.swift
//  SocketIO+RxSwift
//
//  Created by hansol on 2024/07/02.
//

import Foundation
import RxSwift

class ChatViewModel {
    // ✨ 소켓 연결해야함
    var selectedChatSubject: BehaviorSubject<ChatList> = BehaviorSubject(value: ChatList(roomName: "", headCount: "0"))
 

    init(_ selectedChat: ChatList) {
        self.selectedChatSubject = BehaviorSubject(value: selectedChat)
    }
    
    // ✨ 소켓 연결 로직
    func connectRoom(_ roomName: String) {
        SocketIOManager.shared.connectRoom()
    }
    
    func disConnectRoom() {
        SocketIOManager.shared.disConnectRoom()
    }
}
