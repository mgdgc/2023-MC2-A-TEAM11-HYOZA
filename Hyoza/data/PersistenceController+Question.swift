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
    
    func filteredQuestion(which questionStatus: QuestionStatus) -> [Question] {
        let questionRequest: NSFetchRequest<Question> = Question.fetchRequest()
        do {
            switch questionStatus {
            case .hasAnswer:
                questionRequest.predicate = .hasAnswer
                let questionResults = try context.fetch(questionRequest)
                return questionResults
            case .isNotChoosenAndEasy:
                // easy hard가 적어도 1개, 나머지 1개는 둘 중 하나.
                questionRequest.predicate = .isNotChoosen && .isEasy
                let questionResults = try context.fetch(questionRequest).shuffled()
                return Array(questionResults[0...1])
            case .isNotChoosenAndHard:
                questionRequest.predicate = .isNotChoosen && .isHard
                let questionResults = try context.fetch(questionRequest).shuffled()
                if let firstQuestion = questionResults.first {
                    return [firstQuestion]
                }
                return []
            }
        } catch {
            print(":( filteredQuestion에서 오류")
            return []
        }
    }
    
    // MARK: - TodayView
    
    var selectedQuestion: Question? {
        let questionRequest: NSFetchRequest<Question> = Question.fetchRequest()
        questionRequest.predicate = .isSelected && .hasNoAnswer
        return try? context.fetch(questionRequest).first
    }
    
    var hasSelected: Bool {
        selectedQuestion != nil
    }
}

enum QuestionStatus {
    case isNotChoosenAndEasy
    case isNotChoosenAndHard
    case hasAnswer
}
