//
//  Date+Ext.swift
//  Student-Management-App
//
//  Created by Sadiq Jatu on 29/07/26.
//

import Foundation


extension Date {
    
    func convertToYearMonthDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter.string(from: self)
    }
}
