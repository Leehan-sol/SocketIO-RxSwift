//
//  ChatViewModel.swift
//  SocketIO+RxSwift
//
//  Created by hansol on 2024/07/02.
//

import Foundation
import RxSwift

class ChatRoomViewModel: ViewModelType {
    let nickname: String
    var chatRoomName: BehaviorSubject<ChatRoom>
    var chatSubject: PublishSubject<[Chat]> = PublishSubject()
    var chatRoomHeadCount: PublishSubject<Int> = PublishSubject()
    
    private var chats: [Chat] = []
    private let disposeBag = DisposeBag()
    
    struct Input {
        let sendButton: PublishSubject<String>
    }
    
    struct Output {
        let chatRoomName: BehaviorSubject<ChatRoom>
        let chatSubject: PublishSubject<[Chat]>
        let chatRoomHeadCount: PublishSubject<Int>
    }
    
    func transform(input: Input) -> Output {
        input.sendButton
            .bind(onNext: { message in
                self.sendMessage(message)
            }).disposed(by: disposeBag)
        
        return Output(chatRoomName: chatRoomName,
                      chatSubject: chatSubject,
                      chatRoomHeadCount: chatRoomHeadCount)
    }
    
    init(_ selectedChatRoomSubject: ChatRoom, _ userNickname: String) {
        self.chatRoomName = BehaviorSubject(value: selectedChatRoomSubject)
        self.nickname = userNickname
        
        connectRoom(selectedChatRoomSubject.roomName)
        setBindings()
    }
    
    deinit {
        if let chat = try? chatRoomName.value() {
            disConnectRoom(chat.roomName)
        }
    }
    
    private func setBindings() {
        SocketIOManager.shared.chatSubject
            .subscribe(onNext: { [weak self] chats in
                self?.chats.append(chats)
                self?.chatSubject.onNext(self?.chats ?? [])
            })
            .disposed(by: disposeBag)
        
        chatRoomName
            .flatMap { selectedChat -> Observable<ChatRoom?> in
                // SocketIOManager.shared.chatListSubject가 바뀔때마다 새롭게 매핑
                SocketIOManager.shared.chatRoomList
                    .map { chatLists -> ChatRoom? in
                        return chatLists.first(where: { $0.roomName == selectedChat.roomName })
                    }
            }
            .subscribe(onNext: { [weak self] currentChatRoom in
                if let room = currentChatRoom {
                    self?.chatRoomHeadCount.onNext(room.headCount)
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    private func connectRoom(_ roomName: String) {
        SocketIOManager.shared.connectRoom(roomName, nickname)
    }
    
    private func disConnectRoom(_ roomName: String) {
        chats = []
        chatSubject.onNext(chats)
        SocketIOManager.shared.disConnectRoom(roomName, nickname)
    }
    
    private func sendMessage(_ text: String) {
        if let currentChat = try? chatRoomName.value() {
            SocketIOManager.shared.sendMessage(currentChat.roomName, nickname, text)
        }
    }
    
}
