//
//  ViewController.swift
//  SocketIO+RxSwift
//
//  Created by hansol on 2024/07/02.
//

import UIKit
import RxSwift
import RxCocoa

class ListViewController: UIViewController {
    private let listView = ListView()
    private let viewModel: ListViewModel
    private let addChatRoomAction: PublishSubject<String> = PublishSubject()
    private let disposeBag = DisposeBag()
    
    init(_ viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = listView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavi()
        setTableView()
        setTapGesture()
        setBindings()
    }
    
    private func setNavi() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setTableView() {
        listView.listTableView.register(ListTableViewCell.self, forCellReuseIdentifier: "listCell")
    }
    
    private func setTapGesture() {
        listView.listTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.listView.listTableView.deselectRow(at: indexPath, animated: true)
                guard let selectedChat = try? self?.viewModel.chatRoomList.value()[indexPath.row] else { return }
                self?.goChatRoom(existingRoom: selectedChat, newRoomName: nil)
            }).disposed(by: disposeBag)
        
        listView.addChatRoomButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.showAlertWithOneTF(title: "새 채팅방 만들기", message: "채팅방 이름을 입력하세요", placeholder: "채팅방 이름", button1: "확인", button2: "취소") { text in
                    if let chatName = text, !chatName.isEmpty {
                        self?.addChatRoomAction.onNext(chatName)
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    private func setBindings() {
        let input = ListViewModel.Input(addChatRoom: addChatRoomAction)
        let output = viewModel.transform(input: input)
        
        output.chatRoomList
            .bind(to: listView.listTableView.rx.items(cellIdentifier: "listCell", cellType: ListTableViewCell.self)) { index, item, cell in
                cell.configure(with: item)
            }.disposed(by: disposeBag)
        
        output.showAlert
            .subscribe { [weak self] title, message in
                self?.showAlert(title, message)
            }.disposed(by: disposeBag)
        
        output.goNavi
            .subscribe(onNext: { [weak self] roomName in
                self?.goChatRoom(existingRoom: nil, newRoomName: roomName)
            }).disposed(by: disposeBag)
    }
    

    private func goChatRoom(existingRoom: ChatRoom?, newRoomName: String?) {
        let chatRoom = existingRoom != nil ? existingRoom! : ChatRoom(roomName: newRoomName ?? "", headCount: 0)
        let chatRoomVM = ChatRoomViewModel(chatRoom, viewModel.nickname)
        let chatRoomVC = ChatRoomViewController(chatRoomVM)
        self.navigationController?.pushViewController(chatRoomVC, animated: true)
    }

    
}

