//
//  ChatViewController.swift
//  SocketIO+RxSwift
//
//  Created by hansol on 2024/07/02.
//

import UIKit
import RxSwift
import RxCocoa

class ChatRoomViewController: UIViewController {
    private let chatRoomView = ChatRoomView()
    private let viewModel: ChatRoomViewModel
    private let sendMessageAction: PublishSubject<String> = PublishSubject()
    private let disposeBag = DisposeBag()
    
    init(_ viewModel: ChatRoomViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func loadView() {
        view = chatRoomView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setKeyboard()
        setTapGesture()
        setBindings()
    }
    
    private func setTableView() {
        chatRoomView.chatTableView.register(ChatTableViewCell.self, forCellReuseIdentifier: "chatCell")
    }
    
    private func setKeyboard() {
        KeyboardManager.shared.keyboardHeight()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] keyboardHeight in
                guard let self = self else { return }
                KeyboardManager.shared.adjustViewForKeyboardHeight(in: self.view, with: keyboardHeight)
            }).disposed(by: disposeBag)
        
        KeyboardManager.shared.setupDismissKeyboardGesture(for: view, target: self, selector: #selector(dismissKeyboard))
    }
    
    @objc func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func setTapGesture() {
        chatRoomView.backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        chatRoomView.sendButton.rx.tap
            .map { [weak self] _ in
                self?.chatRoomView.chatTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { ($0 ?? "").isEmpty == false }
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] text in
                self?.chatRoomView.chatTextField.text = ""
                self?.sendMessageAction.onNext(text)
            })
            .disposed(by: disposeBag)
    }
    
    private func setBindings() {
        let input = ChatRoomViewModel.Input(sendButton: sendMessageAction)
        let output = viewModel.transform(input: input)
        
        output.chatRoomName
            .map { $0.roomName }
            .bind(to: chatRoomView.roomNameLabel.rx.text )
            .disposed(by: disposeBag)
        
        output.chatSubject
            .bind(to: chatRoomView.chatTableView.rx.items(cellIdentifier: "chatCell", cellType: ChatTableViewCell.self)) { [weak self] index, item, cell in
                cell.configure(with: item, userNickname: self?.viewModel.nickname ?? "")
            }
            .disposed(by: disposeBag)
        
        output.chatSubject
            .subscribe { [weak self] _ in
                self?.scrollToBottom()
            }
            .disposed(by: disposeBag)
        
        output.chatRoomHeadCount
            .map { "(\($0)명)"}
            .bind(to: chatRoomView.headCountLabel.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    
    private func scrollToBottom() {
        let lastRow = self.chatRoomView.chatTableView.numberOfRows(inSection: 0) - 1
        if lastRow >= 0 {
            let indexPath = IndexPath(row: lastRow, section: 0)
            self.chatRoomView.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    
}
