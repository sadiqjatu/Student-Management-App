//
//  String+Ext.swift
//  Student-Management-App
//
//  Created by Sadiq Jatu on 30/07/26.
//

import Foundation


extension String {
    
    // String -> Date -> String
    func formatToMonthDateYear() -> String {
        let formatter        = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        //comvert to date
        guard let date = formatter.date(from: self) else {
            return self
        }
        
        formatter.dateFormat = "MMM d, yyyy"
        
        return formatter.string(from: date)
    }
}
