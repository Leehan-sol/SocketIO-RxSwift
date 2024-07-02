//
//  SignUpView.swift
//  SocketIO+RxSwift
//
//  Created by hansol on 2024/07/02.
//

import UIKit
import SnapKit

class SignUpView: UIView {
    
    private let signUpLabel: UILabel = {
        let label = UILabel()
        label.text = "채팅에서 사용할 닉네임을 입력해주세요."
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .title1).pointSize)
        return label
    }()
    
    let signUpTextField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "닉네임을 입력해주세요."
        tf.borderStyle = .roundedRect
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.layer.cornerRadius = 10
        tf.layer.borderWidth = 1
        return tf
    }()
    
    let signUpButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .gray
        btn.isEnabled = false
        btn.setTitle("확인", for: .normal)
        btn.tintColor = .white
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.layer.cornerRadius = 10
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
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
        
        let subviews = [signUpLabel, signUpTextField, signUpButton]
        
        subviews.forEach { addSubview($0) }
        
        signUpLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(150)
            $0.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(50)
            $0.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).inset(50)
        }
        
        signUpTextField.snp.makeConstraints {
            $0.top.equalTo(signUpLabel.snp.bottom).offset(50)
            $0.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(50)
            $0.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).inset(50)
            $0.height.equalTo(50)
        }
        
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(signUpTextField.snp.bottom).offset(100)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(40)
        }
        
    }
    
    
}
