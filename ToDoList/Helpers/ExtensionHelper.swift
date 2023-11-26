//
//  ExtensionHelper.swift
//  ToDoList
//
//  Created by 김진수 on 2023/10/30.
//

import Foundation

extension DateInterval {
    func closest(to date: Date, calendar: Calendar) -> DateComponents {
        let closestDate: Date?
        let closestDateComponents: DateComponents?
        
        if start > date {
            closestDate = start
        } else if end < date {
            closestDate = end
        } else {
            closestDate = nil
        }
        
        closestDateComponents = calendar.dateComponents([.year, .month, .day], from: closestDate!)
        
        return closestDateComponents!
    }
}

extension Date {
    public var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    public var month: Int {
         return Calendar.current.component(.month, from: self)
    }
    
    public var day: Int {
         return Calendar.current.component(.day, from: self)
    }
    
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월" // 2022-07-03 23:14
        return dateFormatter.string(from: self)
    }
}
