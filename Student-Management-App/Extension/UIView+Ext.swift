//
//  UIView+Ext.swift
//  Student-Management-App
//
//  Created by Sadiq Jatu on 07/07/26.
//

import UIKit


extension UIView {
    
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
