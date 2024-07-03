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
    private let disposeBag = DisposeBag()
    
    
    private init() {
        manager = SocketManager(socketURL: URL(string: "http://localhost:3009")!, config: [.log(true), .compress])
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
        
        socket.on("chatList") { [weak self] data, ack in
            guard let self = self, let jsonString = data[0] as? String else { return }
            
            do {
                let jsonData = try JSONDecoder().decode([ChatList].self, from: jsonString.data(using: .utf8)!)
                self.chatListSubject.onNext(jsonData)
            } catch {
                print("Error decoding chatList:", error)
            }
        }

        //        socket.on("newMessage") { data, ack in
        //            if let message = data[0] as? String {
        //                print("New message: \(message)")
        //            }
        //        }
    }
    
    
    func connectRoom() {
        
    }
    
    func disConnectRoom() {
        
    }
    
    
    func sendData(text: String) {
        socket.emit("newMessage", text)
        print("메세지 전송")
    }
    
    
}
