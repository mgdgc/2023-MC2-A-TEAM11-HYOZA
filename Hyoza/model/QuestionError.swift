//
//  QuestionError.swift
//  Hyoza
//
//  Created by sei on 2023/05/12.
//

import Foundation

enum QuestionError: Error {
    case wrongDataFormat(error: Error)
    case missingData
    case batchInsertError
    case unexpectedError(error: Error)
}

extension QuestionError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .wrongDataFormat(let error):
            return NSLocalizedString("Could not digest the fetched data. \(error.localizedDescription)", comment: "")
        case .missingData:
            return NSLocalizedString("Found and will discard a question missing a valid question, id, or difficulty.", comment: "")
        case .batchInsertError:
            return NSLocalizedString("Failed to execute a batch insert request.", comment: "")
        case .unexpectedError(let error):
            return NSLocalizedString("Received unexpected error. \(error.localizedDescription)", comment: "")
        }
    }
}

extension QuestionError: Identifiable {
    var id: String? {
        errorDescription
    }
}
