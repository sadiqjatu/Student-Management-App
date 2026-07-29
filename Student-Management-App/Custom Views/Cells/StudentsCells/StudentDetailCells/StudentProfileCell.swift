//
//  StudentProfileCell.swift
//  Student-Management-App
//
//  Created by Sadiq Jatu on 23/07/26.
//

import UIKit

class StudentProfileCell: UICollectionViewCell {
    
    static let reuseID   = "StudentProfileCell"
    let contatinerView   = UIView()
    let iconImageView    = SMIconView(iconSize: 40, cornerRadius: 45)
    let studentNameLabel = SMTitleLabel(textAlignment: .center, fontSize: 28)
    let classNameLabel   = SMSecondaryTitleLabel(text: "", textAlignment: .center, fontSize: 18)
    let padding: CGFloat = 16
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        contentView.addSubview(contatinerView)
        contatinerView.addSubviews(iconImageView, studentNameLabel, classNameLabel)
        
        contatinerView.translatesAutoresizingMaskIntoConstraints = false
        
        contatinerView.layer.cornerRadius  = 16
        contatinerView.clipsToBounds = true
        contatinerView.backgroundColor     = Colors.darkBlue
        
        iconImageView.icon.image           = Icons.person
        iconImageView.icon.tintColor       = .white
        iconImageView.backgroundColor      = .systemGray2
        iconImageView.layer.borderColor    = UIColor.systemGray3.cgColor
        iconImageView.layer.borderWidth    = 4
        
        //override the colors
        studentNameLabel.textColor         = UIColor.white
        classNameLabel.textColor           = Colors.lightGray
        
        NSLayoutConstraint.activate([
            contatinerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contatinerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contatinerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contatinerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            iconImageView.topAnchor.constraint(equalTo: contatinerView.topAnchor, constant: padding),
            iconImageView.centerXAnchor.constraint(equalTo: contatinerView.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 90),
            iconImageView.heightAnchor.constraint(equalToConstant: 90),
            
            studentNameLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: padding),
            studentNameLabel.centerXAnchor.constraint(equalTo: contatinerView.centerXAnchor),
            studentNameLabel.heightAnchor.constraint(equalToConstant: 32),
            
            classNameLabel.topAnchor.constraint(equalTo: studentNameLabel.bottomAnchor, constant: padding-10),
            classNameLabel.centerXAnchor.constraint(equalTo: contatinerView.centerXAnchor),
            classNameLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
}
