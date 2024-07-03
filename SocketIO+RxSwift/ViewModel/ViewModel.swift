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
    
    var chatListSubject: BehaviorSubject<[ChatList]> = BehaviorSubject(value: [ChatList]())
    private let disposeBag = DisposeBag()
    
    
    init() {
        setBindings()
    }
    
    func setBindings() {
        SocketIOManager.shared.setupSocket()
        SocketIOManager.shared.chatListSubject
            .bind(to: chatListSubject)
            .disposed(by: disposeBag)
    }
    
}

