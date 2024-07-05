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
    var validNickname: Observable<Bool> {
        return nickNameSubject.map { nickName in
            guard let nickName = nickName else { return false }
            return !nickName.isEmpty && nickName.count <= 10
        }
    }
    
    var chatListSubject: BehaviorSubject<[ChatList]> = BehaviorSubject(value: [ChatList]())
    private let disposeBag = DisposeBag()
    
    
    init() {
        SocketIOManager.shared.setupSocket()
        setBindings()
    }
    
    func setBindings() {
        SocketIOManager.shared.chatListSubject
            .bind(to: chatListSubject)
            .disposed(by: disposeBag)
    }
    
    func addChatList(_ newChatName: String) {
        SocketIOManager.shared.addChatList(newChatName)
    }
}

