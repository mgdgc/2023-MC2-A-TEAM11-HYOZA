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
    static func hasAnswerAndContains(key: String) -> NSPredicate {
        NSCompoundPredicate(andPredicateWithSubpredicates: [.hasAnswer, .contains(key: key)])
    }
    static let isNotChoosen = NSPredicate(format: "timestamp == nil")
    static func timestampIn(between startDate: Date, and endDate: Date) -> NSPredicate {
        return NSPredicate(
            format: "timestamp >= %@ AND timestamp < %@", startDate.start as NSDate,
            endDate.end as NSDate)
    }
}
