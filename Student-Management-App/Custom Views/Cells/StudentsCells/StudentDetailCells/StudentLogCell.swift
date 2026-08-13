//
//  StudentLogCell.swift
//  Student-Management-App
//
//  Created by Sadiq Jatu on 23/07/26.
//

import UIKit

enum StudentLogCellType {
    case present, absent, tardy, grade
}

class StudentLogCell: UICollectionViewCell {
    
    static let reuseID    = "StudentLogCell"
    let containerView     = UIView()
    let logNameLabel      = SMSecondaryTitleLabel(text: "", textAlignment: .left, fontSize: 18)
    let logValue          = SMSecondaryTitleLabel(text: "", textAlignment: .right, fontSize: 18)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContainerView()
        configureContent()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureContainerView() {
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    
    private func configureContent() {
        containerView.addSubviews(logNameLabel, logValue)
        
        NSLayoutConstraint.activate([
            logNameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            logNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            logNameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            logValue.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            logValue.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            logValue.leadingAnchor.constraint(greaterThanOrEqualTo: logNameLabel.trailingAnchor, constant: 16),
            logValue.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    
    func set(type: StudentLogCellType, value: String, testName: String?, maxPoints: String?) {
        
        switch type {
            
        case .present:
            logValue.textColor     = Colors.green
            logValue.text          = "Present"
            logNameLabel.text      = value.formatToMonthDateYear()
        case .absent:
            logValue.textColor     = Colors.red
            logValue.text          = "Absent"
            logNameLabel.text      = value.formatToMonthDateYear()
        case .tardy:
            logValue.textColor     = Colors.yellow
            logValue.text          = "Tardy"
            logNameLabel.text      = value.formatToMonthDateYear()
        case .grade:
            logValue.textColor     = .label
            logNameLabel.textColor = .label
            logValue.text          = "\(value)/\(maxPoints ?? "N/A")"
            logNameLabel.text      = testName
        }
    }
}
