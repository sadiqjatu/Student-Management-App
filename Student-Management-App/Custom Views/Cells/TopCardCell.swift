//
//  TopCardCell.swift
//  Student-Management-App
//
//  Created by Sadiq Jatu on 06/07/26.
//

import UIKit

class TopCardCell: UICollectionViewCell {
    
    static let reuseID = "TopCardCell"
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        
    }
}
