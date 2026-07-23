//
//  TopCardCell.swift
//  Student-Management-App
//
//  Created by Sadiq Jatu on 06/07/26.
//

import UIKit

enum TopCardType {
    case roster, attendance
}

class TopCardCell: UICollectionViewCell {
    
    static let reuseID        = "TopCardCell"
    let containerView         = UIView()
    let iconView              = SMIconView()
    let topCardValue          = SMTitleLabel(textAlignment: .left, fontSize: 32)
    let topCardValueLabel     = SMTertitaryTitleLabel(textAlignment: .left, fontSize: 16)
    let innerPadding: CGFloat = 16
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        configureContent()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupLayout() {
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.layer.cornerRadius  = 18
        containerView.layer.masksToBounds = true
        containerView.backgroundColor     = .systemBackground
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    
    private func configureContent() {
        containerView.addSubviews(iconView, topCardValue, topCardValueLabel)
        
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: innerPadding),
            iconView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: innerPadding),
            iconView.heightAnchor.constraint(equalToConstant: 36),
            iconView.widthAnchor.constraint(equalToConstant: 36),
            
            
            topCardValue.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 5),
            topCardValue.leadingAnchor.constraint(equalTo: iconView.leadingAnchor),
            topCardValue.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -innerPadding),
            topCardValue.heightAnchor.constraint(equalToConstant: 36),
            
            topCardValueLabel.topAnchor.constraint(equalTo: topCardValue.bottomAnchor, constant: 5),
            topCardValueLabel.leadingAnchor.constraint(equalTo: iconView.leadingAnchor),
            topCardValueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -innerPadding),
            topCardValueLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    
    func set(type: TopCardType, value: String) {
        
        switch type {
        case .roster:
            iconView.icon.image      = Icons.twoPerson
            iconView.backgroundColor = Colors.lightBlue
            iconView.icon.tintColor  = Colors.blue
            topCardValueLabel.text   = "Total Roster"
            topCardValue.text        = value
        case .attendance:
            iconView.icon.image      = Icons.calendarCheckmark
            iconView.backgroundColor = Colors.lightGreen
            iconView.icon.tintColor  = Colors.green
            topCardValueLabel.text   = "Today's Attendance"
            topCardValue.text        = value
        }
    }
}
