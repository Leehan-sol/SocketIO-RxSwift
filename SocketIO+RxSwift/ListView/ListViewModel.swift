//
//  ListViewModel.swift
//  SocketIO+RxSwift
//
//  Created by hansol on 2024/07/02.
//

import Foundation
import RxSwift

class ListViewModel: ViewModelType {
    let nickname: String
    var chatRoomList: BehaviorSubject<[ChatRoom]> = BehaviorSubject(value: [ChatRoom]())
    var showAlert: PublishSubject<(String, String)> = PublishSubject()
    var goNavi: PublishSubject<String> = PublishSubject()
    private let disposeBag = DisposeBag()
    
    
    struct Input {
        let addChatRoom: PublishSubject<String>
    }
    
    struct Output {
        let chatRoomList: BehaviorSubject<[ChatRoom]>
        let showAlert: PublishSubject<(String, String)>
        let goNavi: PublishSubject<String>
    }
    
    func transform(input: Input) -> Output {
        input.addChatRoom
            .bind(onNext: { title in
                self.addChatRoom(title)
            }).disposed(by: disposeBag)
        
        return Output(chatRoomList: chatRoomList,
                          showAlert: showAlert,
                          goNavi: goNavi)
    }
    
    
    init(nickname: String) {
        self.nickname = nickname
        SocketIOManager.shared.setSocket()
        setBindings()
    }
    
    private func setBindings() {
        SocketIOManager.shared.chatRoomList
            .bind(to: chatRoomList)
            .disposed(by: disposeBag)
    }
    
    private func addChatRoom(_ chatName: String) {
        guard let currentChatList = try? chatRoomList.value() else { return }
        print("현재 채팅 목록:", currentChatList)
        
        if currentChatList.contains(where: { $0.roomName == chatName }) {
            showAlert.onNext(("에러","이미 존재하는 채팅방입니다."))
        } else {
            SocketIOManager.shared.addChatRoom(chatName)
            goNavi.onNext(chatName)
        }
    }


}



