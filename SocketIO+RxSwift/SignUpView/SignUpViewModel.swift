//
//  SignUpViewModel.swift
//  SocketIO+RxSwift
//
//  Created by hansol on 2024/07/19.
//

import Foundation
import RxSwift

class SignUpViewModel: ViewModelType {
    
    struct Input {
        let nickname: Observable<String>
    }
    
    struct Output {
        let validNickname: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        let validNickName = input.nickname
            .map { nickname in
                return !nickname.isEmpty && nickname.count <= 10
            }
            .share(replay: 1)
        
        return Output(validNickname: validNickName)
    }
    
}
