//
//  Answer+CoreDataProperties.swift
//  Hyoza
//
//  Created by sei on 2023/05/12.
//

import Foundation
import CoreData


extension Answer {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Answer> {
        return NSFetchRequest<Answer>(entityName: "Answer")
    }

    @NSManaged public var answer: String?
    @NSManaged public var answerTime: Date?
    @NSManaged public var comment: String?
    @NSManaged public var question: Question?

    
    public var answerDetail: String {
        answer ?? "Unknown Answer."
    }
    
    public var commentDetail: String {
        comment ?? "Unknown Comment."
    }
}

extension Answer : Identifiable {

}
