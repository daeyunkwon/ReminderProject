//
//  Date+Extension.swift
//  ReminderProject
//
//  Created by 권대윤 on 7/3/24.
//

import UIKit

extension Date {
    
    static func makeDateString(date: Date) -> String {
        let myFormatter = DateFormatter()
        
        myFormatter.dateFormat = "yyyy.MM.dd(EEE)"
        myFormatter.locale = Locale(identifier: "ko-KR")
        let dateString = myFormatter.string(from: date)
        
        return dateString
    }
    
    static func makeStringToDate(str: String) -> Date {
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyy.MM.dd(EEE)"
        
        let date = myFormatter.date(from: str) ?? Date()
        return date
    }
    
}
