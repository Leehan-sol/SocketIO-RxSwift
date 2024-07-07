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
    private let disposeBag = DisposeBag()
    private let viewModel: ViewModel
    
    init(_ viewModel: ViewModel) {
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
        setBindings()
        setTapGesture()
    }
    
    private func setNavi() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setTableView() {
        listView.listTableView.register(ListTableViewCell.self, forCellReuseIdentifier: "listCell")
        listView.listTableView.delegate = self
    }
    
    private func setBindings() {
        viewModel.chatListSubject
            .bind(to: listView.listTableView.rx.items(cellIdentifier: "listCell", cellType: ListTableViewCell.self)) { index, item, cell in
                cell.configure(with: item)
            }
            .disposed(by: disposeBag)
        
        viewModel.showAlertSubject
            .subscribe { [weak self] title, message in
                self?.showAlert(title, message)
            }
            .disposed(by: disposeBag)
        
        viewModel.naviSubject
            .subscribe(onNext: { [weak self] roomName in
                let newChat = ChatList(roomName: roomName, headCount: 0)
                guard let nickname = try? self?.viewModel.nickNameSubject.value() else { return }
                let chatVM = ChatViewModel(newChat, nickname)
                let chatVC = ChatViewController(chatVM)
                self?.navigationController?.pushViewController(chatVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setTapGesture() {
        listView.listTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                guard let selectedChat = try? self.viewModel.chatListSubject.value()[indexPath.row] else { return }
                guard let nickname = try? self.viewModel.nickNameSubject.value() else { return }
                let chatVM = ChatViewModel(selectedChat,nickname)
                let chatVC = ChatViewController(chatVM)
                navigationController?.pushViewController(chatVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        listView.addChatButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.showAlertWithOneTF(title: "새 채팅방 만들기", message: "채팅방 이름을 입력하세요", placeholder: "채팅방 이름", button1: "확인", button2: "취소") { text in
                    if let chatName = text, !chatName.isEmpty {
                        self?.viewModel.addChatList(chatName)
                    }
                }
            })
            .disposed(by: disposeBag)
        
    }
    
}




// MARK: - UITableViewDelegate
extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
