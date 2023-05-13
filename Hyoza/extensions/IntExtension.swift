//
//  IntExtension.swift
//  Hyoza
//
//  Created by sei on 2023/05/13.
//

import Foundation

extension Int {
    var startOfMonth: Date {
        let myDateComponents = DateComponents(year: Date().year, month: self, day: 1)
        return Calendar.current.date(from: myDateComponents)!
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfMonth)!
    }
}

