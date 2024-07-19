//
//  SocketManager.swift
//  SocketIO+RxSwift
//
//  Created by hansol on 2024/07/02.
//

import Foundation
import SocketIO
import RxSwift

enum SocketEvent: String {
    case addChatList = "addChatList"
    case connectRoom = "connectRoom"
    case disconnectRoom = "disconnectRoom"
    case sendMessage = "sendMessage"
}


class SocketIOManager {
    static let shared = SocketIOManager()
    
    private let manager: SocketManager
    private let socket: SocketIOClient
    private let repository = Repository()
    
    let chatListSubject = BehaviorSubject<[ChatRoom]>(value: [])
    let chatSubject: PublishSubject<Chat> = PublishSubject()
    
    private var handlersAdded = false
    private let disposeBag = DisposeBag()
    
    private init() {
        manager = SocketManager(socketURL: URL(string: "http://localhost:3001")!, config: [.log(true), .compress])
        socket = manager.defaultSocket
    }
    
    func setSocket() {
        disconnectSocket()
        socket.connect()
        socket.on(clientEvent: .connect) {[weak self] data, ack in
            self?.addHandlers()
        }
    }
    
    func disconnectSocket() {
        socket.disconnect()
    }
    
    private func addHandlers() {
        guard !handlersAdded else { return }
        handlersAdded = true
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("소켓 연결 해제")
        }
        
        socket.on(SocketEvent.connectRoom.rawValue) { [weak self] data, ack in
            if let chat = self?.repository.parsingData(SocketEvent.connectRoom, data) as? Chat {
                self?.chatSubject.onNext(chat)
            }
        }
        
        socket.on(SocketEvent.disconnectRoom.rawValue) { [weak self] data, ack in
            if let chat = self?.repository.parsingData(SocketEvent.disconnectRoom, data) as? Chat {
                self?.chatSubject.onNext(chat)
            }
        }
        
        socket.on(SocketEvent.addChatList.rawValue) { [weak self] data, ack in
            if let chatList = self?.repository.parsingData(SocketEvent.addChatList, data) as? [ChatRoom]  {
                self?.chatListSubject.onNext(chatList)
            }
        }
        
        socket.on(SocketEvent.sendMessage.rawValue) { [weak self] data, ack in
            if let chat = self?.repository.parsingData(SocketEvent.sendMessage, data) as? Chat  {
                self?.chatSubject.onNext(chat)
            }
        }
    }
    
    func connectRoom(_ roomName: String, _ userNickname: String) {
        let connectUser = ["roomName" : roomName, "userNickname" : userNickname]
        socket.emit(SocketEvent.connectRoom.rawValue, connectUser)
    }
    
    func disConnectRoom(_ roomName: String, _ userNickname: String) {
        let disconnectUser = ["roomName" : roomName, "userNickname" : userNickname]
        socket.emit(SocketEvent.disconnectRoom.rawValue, disconnectUser)
    }
    
    func addChatRoom(_ newChatName: String) {
        let newChat = ["roomName": newChatName, "headCount": "0"]
        socket.emit(SocketEvent.addChatList.rawValue, newChat)
    }
    
    func sendMessage(_ roomName: String, _ userNickname: String, _ text: String) {
        let newMessage = ["roomName": roomName, "userNickname" : userNickname, "text": text]
        socket.emit(SocketEvent.sendMessage.rawValue, newMessage)
    }
    
    
}
