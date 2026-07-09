//
//  AttentionCell.swift
//  Student-Management-App
//
//  Created by Sadiq Jatu on 06/07/26.
//

import UIKit

enum AttentionCellType {
    case attendance, grade
}

class AttentionCell: UICollectionViewCell {
    
    static let reuseID       = "AttentionCell"
    let containerView        = UIView()
    let studentNameLabel     = SMSecondaryTitleLabel(text: "", textAlignment: .left, fontSize: 22)
    let statusPillView       = UIView()
    let statusLabel          = SMSecondaryTitleLabel(text: "", textAlignment: .left, fontSize: 14)
    let innerPadding:CGFloat = 16
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureContent()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor                           = .systemBackground
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    
    private func configureContent() {
        containerView.addSubviews(studentNameLabel, statusPillView)
        statusPillView.addSubview(statusLabel)
        
        statusPillView.translatesAutoresizingMaskIntoConstraints = false
        
        statusPillView.layer.cornerRadius = 10
        statusPillView.clipsToBounds      = true
        
        NSLayoutConstraint.activate([
            studentNameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            studentNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: innerPadding),
            studentNameLabel.heightAnchor.constraint(equalToConstant: 24),
            
            statusPillView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            statusPillView.leadingAnchor.constraint(greaterThanOrEqualTo: studentNameLabel.trailingAnchor, constant: innerPadding),
            statusPillView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -innerPadding),
            statusPillView.heightAnchor.constraint(equalToConstant: 20),
            statusPillView.widthAnchor.constraint(equalToConstant: 100),
            
            statusLabel.centerXAnchor.constraint(equalTo: statusPillView.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: statusPillView.centerYAnchor)
        ])
    }
    
    
    func set(type: AttentionCellType, studentName: String, status: String) {
        
        switch type {
            
        case .attendance:
            statusPillView.backgroundColor = Colors.lightRed
            statusLabel.textColor          = Colors.red
        case .grade:
            statusPillView.backgroundColor = Colors.lightYellow
            statusLabel.textColor          = Colors.yellow
        }
        
        studentNameLabel.text = studentName
        statusLabel.text      = status
    }
}
