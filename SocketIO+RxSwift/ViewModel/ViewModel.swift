//
//  ViewModel.swift
//  SocketIO+RxSwift
//
//  Created by hansol on 2024/07/02.
//

import Foundation
import RxSwift

class ViewModel {
    
    // Input
    let nickNameSubject = BehaviorSubject<String?>(value: nil)

    // Output
    var isNickNameValid: Observable<Bool> {
        return nickNameSubject.map { nickName in
            guard let nickName = nickName else { return false }
            return !nickName.isEmpty && nickName.count <= 10
        }
    }
    var chatListSubject: BehaviorSubject<[ChatList]>
    
    
    init() {
        // ✨ 소켓에서 받아오는걸로 로직 수정
        // SocketManager.shared.connectSocket()
        let chatList = [ChatList(roomName: "요리 얘기 하실 분~", headCount: 5),
                        ChatList(roomName: "운동 얘기 하실 분~~", headCount: 3),
                        ChatList(roomName: "음악 얘기 하실 분!!", headCount: 4)]
        

        self.chatListSubject = BehaviorSubject(value: chatList)
    }
    
    
    
}

