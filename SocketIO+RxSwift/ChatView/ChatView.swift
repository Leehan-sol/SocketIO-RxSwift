//
//  ChatView.swift
//  SocketIO+RxSwift
//
//  Created by hansol on 2024/07/02.
//

import UIKit

class ChatView: UIView {
    let chatTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "채팅방 이름"
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .title1).pointSize)
        return label
    }()
    
    let chatHeadCountLabel: UILabel = {
        let label = UILabel()
        label.text = "(인원수)"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .caption1).pointSize)
        return label
    }()
    
    let labelsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 10
        sv.alignment = .bottom
        sv.distribution = .fillEqually
        return sv
    }()
    
    let backButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("나가기", for: .normal)
        btn.tintColor = .black
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return btn
    }()
    
    let chatTableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    let chatTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "메세지를 입력해주세요."
        tf.borderStyle = .roundedRect
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.layer.cornerRadius = 10
        tf.layer.borderWidth = 1
        return tf
    }()
    
    let sendButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("전송", for: .normal)
        btn.tintColor = .black
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUI() {
        self.backgroundColor = .systemBackground
        let stackViewSubvies = [chatTitleLabel, chatHeadCountLabel]
        let subviews = [labelsStackView, backButton, chatTableView, chatTextField, sendButton]
        
        subviews.forEach { addSubview($0) }
        stackViewSubvies.forEach { labelsStackView.addArrangedSubview($0) }
        
        labelsStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.lessThanOrEqualTo(backButton.snp.leading).offset(-20)
        }
        
        backButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            $0.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).inset(20)
        }
        
        
        chatTableView.snp.makeConstraints {
            $0.top.equalTo(chatTitleLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalTo(chatTextField.snp.top).offset(-10)
        }
        
        chatTextField.snp.makeConstraints {
            $0.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(sendButton.snp.leading).offset(-10)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-20)
            $0.width.equalTo(300)
        }
        
        sendButton.snp.makeConstraints {
            $0.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-20)
            $0.centerY.equalTo(chatTextField)
        }
    }
    
}
