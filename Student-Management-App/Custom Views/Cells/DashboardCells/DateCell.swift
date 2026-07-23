//
//  DateCell.swift
//  Student-Management-App
//
//  Created by Sadiq Jatu on 11/07/26.
//

import UIKit

class DateCell: UICollectionReusableView {
        
    static let reuseID = "DateCell"
    let containerView  = UIView()
    let dateLabel      = SMTertitaryTitleLabel(textAlignment: .left, fontSize: 22)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        addSubview(containerView)
        containerView.addSubview(dateLabel)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        dateLabel.text  = "June 24, 2026"
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            dateLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            dateLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
