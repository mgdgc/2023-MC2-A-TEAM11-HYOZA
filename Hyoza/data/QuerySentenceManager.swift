//
//  QuerySentenceManager.swift
//  Hyoza
//
//  Created by 최명근 on 2023/05/09.
//

import Foundation

class QuerySentenceManager {
    
    static let shared = QuerySentenceManager()
    
    private static let fileName = "question_samples"
    private static let fileExtension = "json"
    
    private var container: [QuerySentence]?
    
    private init() {
        guard let fileUrl = Bundle.main.url(forResource: QuerySentenceManager.fileName, withExtension: QuerySentenceManager.fileExtension) else {
            return
        }
        
        do {
            let data = try Data(contentsOf: fileUrl)
            container = try? JSONDecoder().decode([QuerySentence].self, from: data)
            
        } catch {
            print(#function, error)
        }
    }
    
    var questions: [QuerySentence] {
        get {
            return self.container ?? []
        }
    }
    
    func filtered(difficulty: QuestionDifficulty? = nil, exceptIds: [Int]? = nil) -> [QuerySentence] {
        var questions = [QuerySentence]()
        questions.append(contentsOf: self.container ?? [])
        
        if let difficulty = difficulty {
            questions = questions.filter { q in
                q.difficulty == difficulty
            }
        }
        
        if let exceptIds = exceptIds {
            questions = questions.filter({ q in
                !exceptIds.contains(where: { i in q.id != i })
            })
        }
        
        return questions
    }
    
}
