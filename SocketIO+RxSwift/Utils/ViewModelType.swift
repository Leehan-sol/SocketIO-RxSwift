//
//  ViewModelType.swift
//  SocketIO+RxSwift
//
//  Created by hansol on 2024/07/19.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
