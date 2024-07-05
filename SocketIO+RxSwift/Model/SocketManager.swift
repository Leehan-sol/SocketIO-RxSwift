//
//  SocketManager.swift
//  SocketIO+RxSwift
//
//  Created by hansol on 2024/07/02.
//

import Foundation
import SocketIO
import RxSwift

class SocketIOManager {
    static let shared = SocketIOManager()
    
    private let manager: SocketManager
    private let socket: SocketIOClient
    
    let chatListSubject = BehaviorSubject<[ChatList]>(value: [])
    let chatSubject: PublishSubject<Chat> = PublishSubject()
    
    private let disposeBag = DisposeBag()
    
    
    private init() {
        manager = SocketManager(socketURL: URL(string: "http://localhost:3001")!, config: [.log(true), .compress])
        socket = manager.defaultSocket
    }
    
    func setupSocket() {
        disconnectSocket()
        socket.connect()
        socket.on(clientEvent: .connect) {[weak self] data, ack in
            self?.addHandlers()
        }
    }
    
    func disconnectSocket() {
        socket.disconnect()
    }
    
    // ✨ 받는 값 chatList까지 합쳐서 enum타입으로 변경, 로직 수정
    func addHandlers() {
        socket.on(clientEvent: .disconnect) {data, ack in
            print("소켓 연결 해제됨")
        }
        
        socket.on("connectRoom") {data, ack in
            guard let dict = data[0] as? [String: Any],
                  let sender = dict["sender"] as? String else { return }
            let connectRoomMessage = Chat(message: "\(sender) 님이 입장했습니다.", sender: "관리자")
            self.chatSubject.onNext(connectRoomMessage)
        }
        
        socket.on("disconnectRoom") {data, ack in
            guard let dict = data[0] as? [String: Any],
                  let sender = dict["sender"] as? String else { return }
            let disconnectRoomMessage = Chat(message: "\(sender) 님이 퇴장했습니다.", sender: "관리자")
            self.chatSubject.onNext(disconnectRoomMessage)
        }
        
        socket.on("chatList") { [weak self] data, ack in
            guard let self = self, let jsonString = data[0] as? String else { return }
            print("jsonString\(jsonString)")
            do {
                let jsonData = try JSONDecoder().decode([ChatList].self, from: jsonString.data(using: .utf8)!)
                self.chatListSubject.onNext(jsonData)
            } catch {
                print("Error decoding chatList:", error)
            }
        }
        
        socket.on("message") { data, ack in
            guard let dict = data[0] as? [String: Any],
                  let text = dict["text"] as? String,
                  let sender = dict["sender"] as? String else { return }
            self.chatSubject.onNext(Chat(message: text, sender: sender))
            print("받은메세지: \(text), \(sender)")
        }
    }
    
    func addChatList(_ newChatName: String) {
        let newChat = ["roomName": newChatName, "headCount": "0"]
        socket.emit("addChatList", newChat)
    }
    
    func connectRoom(_ roomName: String, _ userNickname: String) {
        let connectUser = ["roomName" : roomName, "userNickname" : userNickname]
        socket.emit("connectRoom", connectUser)
    }
    
    func disConnectRoom(_ roomName: String, _ userNickname: String) {
        let disconnectUser = ["roomName" : roomName, "userNickname" : userNickname]
        socket.emit("disconnectRoom", disconnectUser)
    }
    
    
    func sendMessage(_ roomName: String, _ text: String, _ userNickname: String) {
        let newMessage = ["roomName": roomName, "text": text, "userNickname" : userNickname]
        socket.emit("message", newMessage)
    }
    
    
}
