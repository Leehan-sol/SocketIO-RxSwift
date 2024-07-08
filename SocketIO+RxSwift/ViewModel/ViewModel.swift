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
        return nickNameSubject.map { nickname in
            guard let nickname = nickname else { return false }
            return !nickname.isEmpty && nickname.count <= 10
        }
    }
    
    var chatListSubject: BehaviorSubject<[ChatList]> = BehaviorSubject(value: [ChatList]())
    var showAlertSubject: PublishSubject<(String, String)> = PublishSubject()
    var naviSubject: PublishSubject<String> = PublishSubject()
    private let disposeBag = DisposeBag()
    
    
    init() {
        SocketIOManager.shared.setSocket()
        setBindings()
    }
    
    func setBindings() {
        SocketIOManager.shared.chatListSubject
            .bind(to: chatListSubject)
            .disposed(by: disposeBag)
    }
    
    func addChatList(_ chatName: String) {
        guard let currentChatList = try? chatListSubject.value() else { return }
        print("현재 채팅 목록:", currentChatList)
        
        if currentChatList.contains(where: { $0.roomName == chatName }) {
            showAlertSubject.onNext(("오류","이미 존재하는 채팅방입니다."))
        } else {
            SocketIOManager.shared.addChatList(chatName)
            naviSubject.onNext(chatName)
        }
    }
    
    

}



