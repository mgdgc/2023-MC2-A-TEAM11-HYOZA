//
//  PersistenceController+Question.swift
//  Hyoza
//
//  Created by sei on 2023/05/12.
//

import Foundation
import CoreData

// MARK: - Convenient methods for managing questions.
//
extension PersistenceController {
    func addTimestamp(to question: Question) {
        if let context = question.managedObjectContext {
            context.perform {
                question.timestamp = Date()
                context.save(with: .addTimestamp)
            }
        }
    }
    
    
    
    func filteredQuestion(which questionStatus:   QuestionStatus) -> [Question] {
        switch questionStatus {
        case .hasAnswer:
            return []
        case .isNotChoosen:
            return []
        }
    }
}

enum QuestionStatus {
    case isNotChoosen
    case hasAnswer
}
