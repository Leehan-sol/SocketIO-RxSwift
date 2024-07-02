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
    }
    
    private func setTapGesture() {
        listView.listTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                guard let selectedChat = try? self.viewModel.chatListSubject.value()[indexPath.row] else { return }
                let chatVM = ChatViewModel(selectedChat)
                let chatVC = ChatViewController(chatVM)
                navigationController?.pushViewController(chatVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        listView.makeRoomButton.rx.tap
            .subscribe(onNext: { [weak self] in
                // ✨ 채팅방 만들기 로직 추가
                print("생성 버튼 눌림")
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
