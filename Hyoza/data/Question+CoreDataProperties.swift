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

    @NSManaged public var answer: String?
    @NSManaged public var answerTime: Date?
    @NSManaged public var comment: String?
    @NSManaged public var id: Int64
    @NSManaged public var question: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var difficulty: Int32

}

extension Question : Identifiable {

}
