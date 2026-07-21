//
//  SMTextField.swift
//  Student-Management-App
//
//  Created by Sadiq Jatu on 12/07/26.
//

import UIKit

class SMTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    
    convenience init(placeholder: String, fontSize: CGFloat, textAlignment: NSTextAlignment) {
        self.init(frame: .zero)
        self.placeholder   = placeholder
        self.font          = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        self.textAlignment = textAlignment
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        adjustsFontSizeToFitWidth = true
        textColor                 = .secondaryLabel
        minimumFontSize           = 14
        autocorrectionType        = .no
        layer.cornerRadius        = 16
    }
}
