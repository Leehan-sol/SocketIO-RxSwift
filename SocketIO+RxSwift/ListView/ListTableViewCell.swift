//
//  ListTableViewCell.swift
//  SocketIO+RxSwift
//
//  Created by hansol on 2024/07/02.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    let roomNameLabel: UILabel = {
        let label = UILabel()
        label.text = "채팅방 이름"
        label.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .title3).pointSize)
        return label
    }()
    
    let headCountLabel: UILabel = {
        let label = UILabel()
        label.text = "인원수"
        label.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .caption1).pointSize)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        let subviews = [roomNameLabel, headCountLabel]
        
        subviews.forEach { contentView.addSubview($0) }
        
        roomNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.lessThanOrEqualTo(headCountLabel.snp.leading).offset(-16)
            $0.bottom.equalToSuperview().offset(-12)
        }
        
        headCountLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
    
    func configure(with chatList: ChatList) {
        roomNameLabel.text = chatList.roomName
        headCountLabel.text = "\(chatList.headCount) 명"
    }
}
