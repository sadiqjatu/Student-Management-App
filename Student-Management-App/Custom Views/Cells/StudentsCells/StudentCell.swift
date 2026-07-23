//
//  StudentCell.swift
//  Student-Management-App
//
//  Created by Sadiq Jatu on 10/07/26.
//

import UIKit

class StudentCell: UITableViewCell {
    
    static let reuseId   = "StudentCell"
    let containerView    = UIView()
    let profileIcon      = SMIconView(iconSize: 25, cornerRadius: 20)
    let studentNameLabel = SMSecondaryTitleLabel(text: "", textAlignment: .left, fontSize: 20)
    let idLabel          = SMTertitaryTitleLabel(textAlignment: .left, fontSize: 14)
    let gradeLabel       = SMTertitaryTitleLabel(textAlignment: .left, fontSize: 14)
    let chevronIcon      = SMIconView(iconSize: 16, cornerRadius: 12)
    
    let padding: CGFloat = 16
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureContainerView()
        configureContent()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureContainerView() {
        contentView.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor       = .systemBackground
        contentView.backgroundColor         = .clear
        backgroundColor                     = .clear
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    
    private func configureContent() {
        containerView.addSubviews(profileIcon, studentNameLabel, idLabel, gradeLabel, chevronIcon)
        
        profileIcon.icon.image      = Icons.person
        profileIcon.icon.tintColor  = .white
        profileIcon.backgroundColor = .systemGray2
        
        chevronIcon.icon.image      = Icons.chevronRight
        chevronIcon.icon.tintColor  = .systemGray2
        
        NSLayoutConstraint.activate([
            profileIcon.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            profileIcon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            profileIcon.widthAnchor.constraint(equalToConstant: 40),
            profileIcon.heightAnchor.constraint(equalToConstant: 40),
            
            studentNameLabel.topAnchor.constraint(equalTo: profileIcon.topAnchor),
            studentNameLabel.leadingAnchor.constraint(equalTo: profileIcon.trailingAnchor, constant: 10),
            studentNameLabel.heightAnchor.constraint(equalToConstant: 22),
            
            idLabel.topAnchor.constraint(equalTo: studentNameLabel.bottomAnchor, constant: 5),
            idLabel.leadingAnchor.constraint(equalTo: studentNameLabel.leadingAnchor),
            idLabel.heightAnchor.constraint(equalToConstant: 16),
            
            gradeLabel.topAnchor.constraint(equalTo: studentNameLabel.bottomAnchor, constant: 5),
            gradeLabel.leadingAnchor.constraint(equalTo: idLabel.trailingAnchor),
            gradeLabel.heightAnchor.constraint(equalToConstant: 16),
            
            chevronIcon.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            chevronIcon.leadingAnchor.constraint(greaterThanOrEqualTo: gradeLabel.trailingAnchor, constant: 15),
            chevronIcon.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            chevronIcon.widthAnchor.constraint(equalToConstant: 24),
            chevronIcon.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
