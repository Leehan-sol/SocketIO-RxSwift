//
//  Repository.swift
//  SocketIO+RxSwift
//
//  Created by hansol on 2024/07/07.
//

import Foundation

struct Repository {
    
    func parsingData(_ event: SocketEvent, _ data: [Any]) -> Any? {
        switch event {
        case .addChatList:
            return parseChatList(data)
        case .connectRoom:
            let dict = data[0] as? [String: Any]
            let sender = dict?["sender"] as? String ?? "알 수 없는 사용자"
            let connectRoomMessage = Chat(message: "\(sender) 님이 입장했습니다.", sender: "관리자")
            return connectRoomMessage
        case .disconnectRoom:
            let dict = data[0] as? [String: Any]
            let sender = dict?["sender"] as? String ?? "알 수 없는 사용자"
            let disconnectRoomMessage = Chat(message: "\(sender) 님이 퇴장했습니다.", sender: "관리자")
            return disconnectRoomMessage
        case .sendMessage:
            let dict = data[0] as? [String: Any]
            let text = dict?["text"] as? String ?? ""
            let sender = dict?["sender"] as? String ?? "알 수 없는 사용자"
            let message = Chat(message: text, sender: sender)
            return message
        }
        
    }
    
    
    private func parseChatList(_ data: [Any]) -> [ChatRoom] {
        guard let jsonString = data[0] as? String else { return [] }
        
        do {
            let jsonData = try JSONDecoder().decode([ChatRoom].self, from: Data(jsonString.utf8))
            return jsonData
        } catch {
            print("채팅방 목록을 불러오는 데 실패했습니다: \(error)")
            return []
        }
    }
    
}
