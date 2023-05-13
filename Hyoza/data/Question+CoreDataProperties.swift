//
//  Question+CoreDataProperties.swift
//  Hyoza
//
//  Created by 최명근 on 2023/05/04.
//
//

import Foundation
import CoreData

extension Question {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Question> {
        return NSFetchRequest<Question>(entityName: "Question")
    }

    // MARK: - Relationships
    @NSManaged public var answer: Answer?
    
    // MARK: - Attributes
    @NSManaged public var id: Int64
    @NSManaged public var question: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var difficulty: Int32

    public var wrappedQuestion: String {
        question ?? "Unknown Question"
    }
    
    public var wrappedTimestamp: Date {
        timestamp ?? Date()
    }
    
    public var wrappedAnswer: Answer {
        answer ?? Answer()
    }
    
    public var difficultyString: String {
        switch difficulty {
        case 0:
            return Difficulty.easy.rawValue
        default:
            return Difficulty.difficult.rawValue
        }
    }
}

extension Question : Identifiable {

}

extension Question {
    enum Difficulty: String {
        case easy = "쉬움"
        case difficult = "어려움"
    }
}
