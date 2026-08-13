//
//  AssignmentCell.swift
//  Student-Management-App
//
//  Created by Sadiq Jatu on 01/08/26.
//

import UIKit

class AssignmentCell: UITableViewCell {
    
    static let reuseId      = "AssignmentCell"
    let containerView       = UIView()
    let innerContainerView  = UIView()
    let assignmentNameLabel = SMSecondaryTitleLabel(text: "", textAlignment: .left, fontSize: 20)
    let dueDateLabel        = SMTertitaryTitleLabel(textAlignment: .left, fontSize: 16)
    let weightLabel         = SMTertitaryTitleLabel(textAlignment: .left, fontSize: 16)
    let avgScoreLabel       = SMTertitaryTitleLabel(textAlignment: .left, fontSize: 18)
    let chevronRightIcon    = SMIconView(iconSize: 16, cornerRadius: 0)
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        contentView.backgroundColor   = .clear
        backgroundColor               = .clear
        selectionStyle                = .none
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    
    private func configureContent() {
        //Add all the UI elements to the container view
        containerView.addSubviews(assignmentNameLabel, dueDateLabel, weightLabel, innerContainerView)
        innerContainerView.addSubviews(avgScoreLabel, chevronRightIcon)
        innerContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        //Set properties as needed
        chevronRightIcon.icon.image           = Icons.chevronRight
        chevronRightIcon.icon.tintColor       = .systemGray3
        chevronRightIcon.icon.backgroundColor = .clear
        
        //pin UI elements by using auto layout constraints
        NSLayoutConstraint.activate([
            
            assignmentNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            assignmentNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            assignmentNameLabel.trailingAnchor.constraint(equalTo: innerContainerView.leadingAnchor, constant: -10),
            assignmentNameLabel.heightAnchor.constraint(equalToConstant: 24),
            
            dueDateLabel.topAnchor.constraint(equalTo: assignmentNameLabel.bottomAnchor, constant: 4),
            dueDateLabel.leadingAnchor.constraint(equalTo: assignmentNameLabel.leadingAnchor),
            dueDateLabel.heightAnchor.constraint(equalToConstant: 18),
            
            weightLabel.topAnchor.constraint(equalTo: dueDateLabel.topAnchor),
            weightLabel.leadingAnchor.constraint(equalTo: dueDateLabel.trailingAnchor),
            weightLabel.trailingAnchor.constraint(equalTo: innerContainerView.leadingAnchor, constant: -10),
            weightLabel.heightAnchor.constraint(equalToConstant: 18),
            
            innerContainerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            innerContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            innerContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            innerContainerView.widthAnchor.constraint(equalToConstant: 120),
            
            avgScoreLabel.centerYAnchor.constraint(equalTo: innerContainerView.centerYAnchor),
            avgScoreLabel.leadingAnchor.constraint(greaterThanOrEqualTo: innerContainerView.leadingAnchor),
            avgScoreLabel.trailingAnchor.constraint(equalTo: chevronRightIcon.leadingAnchor, constant: -2),
            avgScoreLabel.heightAnchor.constraint(equalToConstant: 20),
            
            chevronRightIcon.centerYAnchor.constraint(equalTo: innerContainerView.centerYAnchor),
            chevronRightIcon.trailingAnchor.constraint(equalTo: innerContainerView.trailingAnchor, constant: -16),
            chevronRightIcon.heightAnchor.constraint(equalToConstant: 22),
            chevronRightIcon.widthAnchor.constraint(equalToConstant: 22)
        ])
    }
}
