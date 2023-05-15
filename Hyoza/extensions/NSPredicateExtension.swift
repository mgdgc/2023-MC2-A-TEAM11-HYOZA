//
//  NSPredicateExtension.swift
//  Hyoza
//
//  Created by sei on 2023/05/12.
//

import Foundation

extension NSPredicate {
    static let hasAnswer = NSPredicate(format: "answer != nil")
    
    static func contains(key: String) -> NSPredicate {
        NSPredicate(format : "question CONTAINS[cd] %@ OR answer.answer CONTAINS[cd] %@", key, key)
    }
    
    static func timestampIn(between startDate: Date, and endDate: Date) -> NSPredicate {
        return NSPredicate(
            format: "timestamp >= %@ AND timestamp <= %@", startDate.start as NSDate,
            endDate.end as NSDate)
    }
    
    static func answerTimeIn(between startDate: Date, and endDate: Date) -> NSPredicate {
        return NSPredicate(
            format: "answer.answerTime >= %@ AND answer.answerTime <= %@", startDate.start as NSDate,
            endDate.end as NSDate)
    }
    
    // MARK: - TodayView 관련 NSPredicate
    
    static let isNotChoosen = NSPredicate(format: "timestamp == nil")
    static let isHard = NSPredicate(format: "difficulty == 1")
    static let isEasy = NSPredicate(format: "difficulty == 0")
    static let isSelected = NSPredicate(format: "timestamp != nil")
    static let hasNoAnswer = NSPredicate(format: "answer == nil")
    static let wasAnsweredToday = answerTimeIn(between: Date(), and: Date())
}

extension NSPredicate {
    static func && (lhs: NSPredicate, rhs: NSPredicate) -> NSPredicate {
        NSCompoundPredicate(andPredicateWithSubpredicates: [lhs, rhs])
    }
    
    static func || (lhs: NSPredicate, rhs: NSPredicate) -> NSPredicate {
        NSCompoundPredicate(orPredicateWithSubpredicates: [lhs, rhs])
    }
}
