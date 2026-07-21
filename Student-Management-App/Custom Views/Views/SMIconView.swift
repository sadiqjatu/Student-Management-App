//
//  SMIconView.swift
//  Student-Management-App
//
//  Created by Sadiq Jatu on 07/07/26.
//

import UIKit

class SMIconView: UIView {
    
    let icon = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure(iconSize: 25, cornerRadius: 18)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(iconSize: CGFloat, cornerRadius: CGFloat) {
        super.init(frame: .zero)
        configure(iconSize: iconSize, cornerRadius: cornerRadius)
    }
    
    
    private func configure(iconSize: CGFloat, cornerRadius: CGFloat) {
        addSubview(icon)
        
        translatesAutoresizingMaskIntoConstraints      = false
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = cornerRadius
        clipsToBounds      = true
        icon.contentMode   = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            icon.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            icon.heightAnchor.constraint(equalToConstant: iconSize),
            icon.widthAnchor.constraint(equalToConstant: iconSize)
        ])
    }
}
