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
        print("채팅페이지 init")
        super.init(nibName: nil, bundle: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    deinit {
        print("채팅페이지 deinit")
    }
    
    override func loadView() {
        view = chatView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        observeKeyboardHeight()
        setupDismissKeyboard()
        setBindings()
        setTapGesture()
    }
    
    private func setTableView() {
        chatView.chatTableView.register(ChatTableViewCell.self, forCellReuseIdentifier: "chatCell")
    }
    
    
    func observeKeyboardHeight() {
        KeyboardManager.shared.keyboardHeight()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] keyboardHeight in
                guard let self = self else { return }
                KeyboardManager.shared.adjustViewForKeyboardHeight(in: self.view, with: keyboardHeight)
            })
            .disposed(by: disposeBag)
    }
    
    func setupDismissKeyboard() {
        KeyboardManager.shared.setupDismissKeyboardGesture(for: view, target: self, selector: #selector(dismissKeyboard))
    }
    
    
    @objc func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func setBindings() {
        viewModel.chatSubject
            .bind(to: chatView.chatTableView.rx.items(cellIdentifier: "chatCell", cellType: ChatTableViewCell.self)) { [weak self] index, item, cell in
                guard let self = self else { return }
                cell.configure(with: item, userNickname: self.viewModel.userNickname)
            }
            .disposed(by: disposeBag)
        
        viewModel.chatSubject
            .subscribe { [weak self] _ in
                self?.scrollToBottom()
            }
            .disposed(by: disposeBag)
        
        viewModel.chatHeadCountSubject
            .map { "(\($0)명)"}
            .bind(to: chatView.chatHeadCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.selectedChatSubject
            .map { $0.roomName }
            .subscribe(onNext: { [weak self] roomName in
                self?.chatView.chatTitleLabel.text = roomName
            })
            .disposed(by: disposeBag)
    }
    
    
    private func setTapGesture() {
        chatView.backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        chatView.sendButton.rx.tap
            .subscribe(onNext: { [weak self] in
                print("전송버튼 눌림")
                if let text = self?.chatView.chatTextField.text {
                    self?.chatView.chatTextField.text = ""
                    self?.viewModel.sendMessage(text)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func scrollToBottom() {
        let lastRow = self.chatView.chatTableView.numberOfRows(inSection: 0) - 1
        if lastRow >= 0 {
            let indexPath = IndexPath(row: lastRow, section: 0)
            self.chatView.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    
}
