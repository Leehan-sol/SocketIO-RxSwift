//
//  ChatTableViewCell.swift
//  SocketIO+RxSwift
//
//  Created by hansol on 2024/07/02.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    // ✨ 보낸사람 레이블도 만들어야함
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "채팅메세지"
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        self.selectionStyle = .none
        let subviews = [messageLabel]
        
        subviews.forEach { contentView.addSubview($0) }
        
        messageLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.trailing.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-12)
        }
    }
    
    // ✨ 보낸사람 받아서 확인해서 레이블 숨김 처리 하는 로직
    func configure(with chat: Chat) {
        messageLabel.text = ("메세지: \(chat.message) 보낸사람: \(chat.sender)")
//        headCountLabel.text = "\(chatList.headCount) 명"
    }
    
    
}
