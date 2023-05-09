//
//  QuerySentence.swift
//  Hyoza
//
//  Created by 최명근 on 2023/05/09.
//

import Foundation

struct QuerySentence: Codable {
    var id: Int
    var question: String
    var difficulty: QuestionDifficulty
}

enum QuestionDifficulty: Int, Codable {
    case easy = 0
    case hard = 1
}
