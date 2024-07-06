//
//  ChatTableViewCell.swift
//  SocketIO+RxSwift
//
//  Created by hansol on 2024/07/02.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.alignment = .top
        sv.axis = .vertical
        sv.spacing = 5
        sv.distribution = .fill
        return sv
    }()

    let senderLabel: UILabel = {
       let label = UILabel()
        label.text = "보낸 사람"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .caption1).pointSize)
        return label
    }()
    
    let meLabel: UILabel = {
       let label = UILabel()
        label.text = "나"
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .caption1).pointSize)
        return label
    }()
    
    let messageBox: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 5
        return view
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "채팅메세지"
        label.numberOfLines = 0
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
        
        contentView.addSubview(stackView)
        messageBox.addSubview(messageLabel)
        
        let stackViewSubvies = [senderLabel, meLabel, messageBox]
        stackViewSubvies.forEach { stackView.addArrangedSubview($0) }
        
        stackView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview().inset(5)
        }
        
        senderLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(10)
        }
        
        meLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(senderLabel)
        }
        
        messageBox.snp.makeConstraints {
            $0.top.equalTo(senderLabel.snp.bottom).offset(10)
            $0.bottom.leading.trailing.equalToSuperview().inset(10)
        }
        
        messageLabel.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview().inset(5)
        }
        
    }
    
    func configure(with chat: Chat, userNickname: String) {
        messageLabel.text = chat.message
        senderLabel.text = chat.sender
        let isCurrentUser = chat.sender == userNickname

        configureSenderLabel(for: chat.sender, isCurrentUser: isCurrentUser)
    }

    private func configureSenderLabel(for sender: String, isCurrentUser: Bool) {
        senderLabel.isHidden = isCurrentUser ? true : false
        meLabel.isHidden = isCurrentUser ? false : true
    }
}


