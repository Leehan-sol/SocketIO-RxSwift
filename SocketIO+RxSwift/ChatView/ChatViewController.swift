//
//  ChatViewController.swift
//  SocketIO+RxSwift
//
//  Created by hansol on 2024/07/02.
//

import UIKit
import RxSwift
import RxCocoa

class ChatViewController: UIViewController {
    private let chatView = ChatView()
    private let viewModel: ChatViewModel
    private let disposeBag = DisposeBag()
    
    init(_ viewModel: ChatViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = chatView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBindings()
        setTapGesture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.disConnectRoom()
    }
    
    private func setBindings() {
        viewModel.selectedChatSubject
            .map { $0.roomName }
            .subscribe(onNext: { [weak self] roomName in
                self?.chatView.chatTitleLabel.text = roomName
                self?.viewModel.connectRoom(roomName)
            })
            .disposed(by: disposeBag)
    }
    
    
    private func setTapGesture() {
        chatView.backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        // ✨ 소켓에 메세지 보내기
        chatView.sendButton.rx.tap
            .subscribe(onNext: { [weak self] in
                print("전송버튼 눌림")
            })
            .disposed(by: disposeBag)
    }
    
    
}
