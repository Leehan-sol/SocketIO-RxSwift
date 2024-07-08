//
//  ChatViewModel.swift
//  SocketIO+RxSwift
//
//  Created by hansol on 2024/07/02.
//

import Foundation
import RxSwift

class ChatRoomViewModel {
    var selectedChatRoomSubject: BehaviorSubject<ChatList>
    var userNickname: String
    
    var chatRoomHeadCountSubject: PublishSubject<Int> = PublishSubject()
    var chatSubject: PublishSubject<[Chat]> = PublishSubject()
    
    private var chats: [Chat] = []
    private let disposeBag = DisposeBag()
    
    init(_ selectedChatRoomSubject: ChatList, _ userNickname: String) {
        self.selectedChatRoomSubject = BehaviorSubject(value: selectedChatRoomSubject)
        self.userNickname = userNickname
        
        connectRoom(selectedChatRoomSubject.roomName)
        setBindings()
    }
    
    deinit {
        if let chat = try? selectedChatRoomSubject.value() {
            disConnectRoom(chat.roomName)
        }
    }
    
    func setBindings() {
        SocketIOManager.shared.chatSubject
            .subscribe(onNext: { [weak self] chats in
                self?.chats.append(chats)
                self?.chatSubject.onNext(self?.chats ?? [])
            })
            .disposed(by: disposeBag)
        
        selectedChatRoomSubject
            .flatMap { selectedChat -> Observable<ChatList?> in
                SocketIOManager.shared.chatListSubject
                    .map { chatLists -> ChatList? in
                        return chatLists.first(where: { $0.roomName == selectedChat.roomName })
                    }
            }
            .subscribe(onNext: { [weak self] filteredChatList in
                if let chatList = filteredChatList {
                    self?.chatRoomHeadCountSubject.onNext(chatList.headCount)
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    func connectRoom(_ roomName: String) {
        SocketIOManager.shared.connectRoom(roomName, userNickname)
    }
    
    func disConnectRoom(_ roomName: String) {
        chats = []
        chatSubject.onNext(chats)
        SocketIOManager.shared.disConnectRoom(roomName, userNickname)
    }
    
    func sendMessage(_ text: String) {
        if let currentChat = try? selectedChatRoomSubject.value() {
            SocketIOManager.shared.sendMessage(currentChat.roomName, userNickname, text)
        }
    }
    
}

