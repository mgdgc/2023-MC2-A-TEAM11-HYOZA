//
//  PersistenceController+Answer.swift
//  Hyoza
//
//  Created by sei on 2023/05/12.
//

import Foundation
import CoreData

// MARK: - Convenient methods for managing answers.
//
extension PersistenceController {
    func addAnswer(content answerDetail: String, relateTo question: Question) {
        if let context = question.managedObjectContext {
            context.performAndWait {
                    let answer = Answer(context: context)
                    answer.answer = answerDetail
                    answer.answerTime = Date()
                    answer.question = question
                context.save(with: .addAnswer)
            }
        }
    }
    
    func updateAnswer(content answerDetail: String, relateTo question: Question) {
        if let context = question.managedObjectContext {
            context.performAndWait {
                if let answer = question.answer {
                    answer.answer = answerDetail
                    context.save(with: .updateAnswer)
                } else {
                    addAnswer(content: answerDetail, relateTo: question)
                }
            }
        }
    }
    
    func addComment(detail commentDetail: String, relatedTo question: Question) {
        if let context = question.managedObjectContext {
            context.performAndWait {
                if let answer = question.answer {
                    answer.comment = commentDetail
                }
                context.save(with: .addComment)
            }
        }
    }
    
    func deleteComment(relatedTo question: Question) {
        if let context = question.managedObjectContext {
            context.performAndWait {
                if let answer = question.answer {
                    answer.comment = nil
                }
                context.save(with: .deleteComment)
            }
        }
    }
}
