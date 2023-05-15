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
        guard selectedQuestion == nil else { return }
        if let context = question.managedObjectContext {
            context.performAndWait {
                question.timestamp = Date()
                context.save(with: .addTimestamp)
            }
        }
    }
    
    func filteredQuestion(which questionStatus: QuestionStatus) -> [Question] {
        let questionRequest: NSFetchRequest<Question> = Question.fetchRequest()
        
        switch questionStatus {
        case .hasAnswer:
            questionRequest.predicate = .hasAnswer
        case .isNotChoosenAndEasy:
            // easy hard가 적어도 1개, 나머지 1개는 둘 중 하나.
            questionRequest.predicate = .isNotChoosen && .isEasy
        case .isNotChoosenAndHard:
            questionRequest.predicate = .isNotChoosen && .isHard
        }
        let questionResults: [Question] = (try? container.viewContext.fetch(questionRequest)) ?? []
        return questionStatus == .hasAnswer ? questionResults : questionResults.shuffled()
    }
    
    // MARK: - TodayView
    
    var selectedQuestion: Question? {
        let questionRequest: NSFetchRequest<Question> = Question.fetchRequest()
        questionRequest.predicate = .isSelected && .hasNoAnswer
        return try? container.viewContext.fetch(questionRequest).first
    }
    
    var easyQuestions: [Question] {
        filteredQuestion(which: .isNotChoosenAndEasy)
    }
    
    var hardQuestions: [Question] {
        filteredQuestion(which: .isNotChoosenAndHard)
    }
    
    var oldestAnsweredQuestion: Question? {
        let questionRequest: NSFetchRequest<Question> = Question.fetchRequest()
        questionRequest.predicate = .hasAnswer
        questionRequest.sortDescriptors = [.byTimestamp(ascending: true)]
        return try? container.viewContext.fetch(questionRequest).first
    }
    
    var latestAnsweredQuestion: Question? {
        let questionRequest: NSFetchRequest<Question> = Question.fetchRequest()
        questionRequest.predicate = .hasAnswer
        questionRequest.sortDescriptors = [.byTimestamp(ascending: false)]
        return try? container.viewContext.fetch(questionRequest).first
    }
    
    var todayAnsweredQuestion: Question? {
        let questionRequest: NSFetchRequest<Question> = Question.fetchRequest()
        questionRequest.predicate = .wasAnsweredToday
        return try? container.viewContext.fetch(questionRequest).first
    }
}

enum QuestionStatus {
    case isNotChoosenAndEasy
    case isNotChoosenAndHard
    case hasAnswer
}


