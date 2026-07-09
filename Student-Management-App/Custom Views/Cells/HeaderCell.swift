//
//  HeaderCell.swift
//  Student-Management-App
//
//  Created by Sadiq Jatu on 07/07/26.
//

import UIKit

class HeaderCell: UICollectionReusableView {
    
    static let reuseID  = "HeaderCell"
    let containerView   = UIView()
    let headerTitle     = SMTitleLabel(textAlignment: .left, fontSize: 24)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        addSubview(containerView)
        containerView.addSubview(headerTitle)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor       = .clear
        headerTitle.text      = "Attention Required"
        headerTitle.textColor = .label
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            headerTitle.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            headerTitle.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            headerTitle.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            headerTitle.heightAnchor.constraint(equalToConstant: 26)
        ])
    }
}
