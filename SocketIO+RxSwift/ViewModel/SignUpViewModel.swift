//
//  SignUpViewModel.swift
//  SocketIO+RxSwift
//
//  Created by hansol on 2024/07/19.
//

import Foundation
import RxSwift

class SignUpViewModel {
    
    struct SignUpInput {
        let nickname: Observable<String>
    }
    
    struct SignUpOutput {
        let validNickname: Observable<Bool>
    }
    
    func transform(input: SignUpInput) -> SignUpOutput {
        let validNickName = input.nickname
            .map { nickname in
                return !nickname.isEmpty && nickname.count <= 10
            }
            .share(replay: 1)
        
        return SignUpOutput(validNickname: validNickName)
    }
    
}
