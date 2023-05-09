//
//  DateExtension.swift
//  Hyoza
//
//  Created by 최명근 on 2023/05/08.
//

import Foundation

extension Date {
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }
    
    var minute: Int {
        return Calendar.current.component(.minute, from: self)
    }
    
    static func - (lhs: Date, rhs: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: -rhs, to: lhs)!
    }
}
