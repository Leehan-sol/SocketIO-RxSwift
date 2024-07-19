//
//  ListViewModel.swift
//  SocketIO+RxSwift
//
//  Created by hansol on 2024/07/02.
//

import Foundation
import RxSwift

class ListViewModel {
    let nickname: String
    var chatListSubject: BehaviorSubject<[ChatRoom]> = BehaviorSubject(value: [ChatRoom]())
    var showAlertSubject: PublishSubject<(String, String)> = PublishSubject()
    var naviSubject: PublishSubject<String> = PublishSubject()
    private let disposeBag = DisposeBag()
    
    
    struct ListInput {
        let addChatRoomTrigger: PublishSubject<String>
    }
    
    struct ListOutput {
        let chatList: BehaviorSubject<[ChatRoom]>
        let showAlertTrigger: PublishSubject<(String, String)>
        let naviTrigger: PublishSubject<String>
    }
    
    func transform(input: ListInput) -> ListOutput {
        input.addChatRoomTrigger
            .bind(onNext: { title in
                self.addChatRoom(title)
            }).disposed(by: disposeBag)
        
        return ListOutput(chatList: chatListSubject,
                          showAlertTrigger: showAlertSubject,
                          naviTrigger: naviSubject)
    }
    
    
    init(nickname: String) {
        self.nickname = nickname
        print("nickname: ", nickname)
        
        SocketIOManager.shared.setSocket()
        setBindings()
    }
    
    func setBindings() {
        SocketIOManager.shared.chatListSubject
            .bind(to: chatListSubject)
            .disposed(by: disposeBag)
    }
    
    func addChatRoom(_ chatName: String) {
        guard let currentChatList = try? chatListSubject.value() else { return }
        print("현재 채팅 목록:", currentChatList)
        
        if currentChatList.contains(where: { $0.roomName == chatName }) {
            showAlertSubject.onNext(("오류","이미 존재하는 채팅방입니다."))
        } else {
            SocketIOManager.shared.addChatRoom(chatName)
            naviSubject.onNext(chatName)
        }
    }
    
    

}



