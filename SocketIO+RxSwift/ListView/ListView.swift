//
//  ListView.swift
//  SocketIO+RxSwift
//
//  Created by hansol on 2024/07/02.
//

import UIKit

class ListView: UIView {
    private let listLabel: UILabel = {
        let label = UILabel()
        label.text = "ChatList"
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .title1).pointSize)
        return label
    }()
    
    let addChatListButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("생성", for: .normal)
        btn.tintColor = .black
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return btn
    }()
    
    let listTableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUI() {
        self.backgroundColor = .systemBackground
        
        let subviews = [listLabel, addChatListButton, listTableView]
        
        subviews.forEach { addSubview($0) }
        
        listLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        addChatListButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            $0.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).inset(20)
        }
        
        listTableView.snp.makeConstraints {
            $0.top.equalTo(listLabel.snp.bottom).offset(5)
            $0.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
        }
        
    }
    
    
    
}

