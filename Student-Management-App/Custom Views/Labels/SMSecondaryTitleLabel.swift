//
//  SMSecondaryTitleLabel.swift
//  Student-Management-App
//
//  Created by Sadiq Jatu on 04/07/26.
//

import UIKit

class SMSecondaryTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(text: String, textAlignment: NSTextAlignment, fontSize: CGFloat) {
        self.init(frame: .zero)
        self.text           = text
        self.textAlignment  = textAlignment
        self.font           = UIFont.systemFont(ofSize: fontSize, weight: .medium)
    }
    
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        adjustsFontSizeToFitWidth = true
        textColor                 = .label
        minimumScaleFactor        = 0.7
        lineBreakMode             = .byTruncatingTail
    }
}
