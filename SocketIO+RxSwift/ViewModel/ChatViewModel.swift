//
//  ChatViewModel.swift
//  SocketIO+RxSwift
//
//  Created by hansol on 2024/07/02.
//

import Foundation
import RxSwift

class ChatViewModel {
    var selectedChatSubject: BehaviorSubject<ChatList>
    var userNickname: String
    
    var chatHeadCountSubject: PublishSubject<Int> = PublishSubject()
    var chatSubject: PublishSubject<[Chat]> = PublishSubject()
    
    
    private var chats: [Chat] = []
    private let disposeBag = DisposeBag()
    
    init(_ selectedChat: ChatList, _ userNickname: String) {
        self.selectedChatSubject = BehaviorSubject(value: selectedChat)
        self.userNickname = userNickname
        
        connectRoom(selectedChat.roomName)
        setBindings()
    }
    
    deinit {
        if let chat = try? selectedChatSubject.value() {
            disConnectRoom(chat.roomName)
        }
    }
    
    func setBindings() {
        SocketIOManager.shared.chatSubject
            .subscribe(onNext: { [weak self] chats in
                guard let self = self else { return }
                self.chats.append(chats)
                self.chatSubject.onNext(self.chats)
            })
            .disposed(by: disposeBag)
        
        selectedChatSubject
            .flatMapLatest { selectedChat -> Observable<[ChatList]> in
                SocketIOManager.shared.chatListSubject
                    .map { chatLists -> [ChatList] in
                        chatLists.filter { $0.roomName == selectedChat.roomName }
                    }
            }
            .subscribe(onNext: { [weak self] filteredChatLists in
                guard let self = self else { return }
                if let chatList = filteredChatLists.first {
                    self.chatHeadCountSubject.onNext(chatList.headCount)
                    print("인원수변경 \(chatList)")
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
        if let currentChat = try? selectedChatSubject.value() {
            SocketIOManager.shared.sendMessage(currentChat.roomName, userNickname, text)
        }
    }
    
}

