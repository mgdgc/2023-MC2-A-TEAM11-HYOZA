//
//  Persistence.swift
//  Hyoza
//
//  Created by 최명근 on 2023/05/04.
//

import Foundation
import CoreData
import OSLog

class PersistenceController: ObservableObject {
    
    // MARK: Logging
    
    let logger = Logger(subsystem: "com.example.apple-samplecode.Earthquakes", category: "persistence")
    
    // MARK: Core Data
    
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // easyQuestion 1, 2
        var newQuestions = [Question]()
        for _ in 0...5 {
            let newQuestion = Question(context: viewContext)
            newQuestion.id = Int64(UUID().hashValue)
            newQuestions.append(newQuestion)
        }
        
        newQuestions[3].timestamp = Date()
        newQuestions[4].timestamp = Date()
        newQuestions[5].timestamp = Date()
        
        newQuestions[0].difficulty = 0
        newQuestions[1].difficulty = 0
        newQuestions[2].difficulty = 1
        newQuestions[3].difficulty = 1
        newQuestions[4].difficulty = 0
        newQuestions[5].difficulty = 0
        
        newQuestions[0].question = "0번째 미리보기 질문입니다."
        newQuestions[1].question = "1번째 미리보기 질문입니다."
        newQuestions[2].question = "2번째 미리보기 질문입니다."
        newQuestions[3].question = "3번째 미리보기 질문입니다."
        newQuestions[4].question = "4번째 미리보기 질문입니다."
        newQuestions[5].question = "5번째 미리보기 질문입니다."
        
        let newAnswer1 = Answer(context: viewContext)
        newAnswer1.answer = "3번째 미리보기 답변입니다."
        newAnswer1.answerTime = Date()
        
        let newAnswer2 = Answer(context: viewContext)
        newAnswer2.answer = "4번째 미리보기 답변입니다."
        newAnswer2.answerTime = Date()
        newAnswer2.comment = "4번째 미리보기 코멘트입니다."
        
        newQuestions[3].answer = newAnswer1
        newQuestions[4].answer = newAnswer2
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    let container: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    /// A peristent history token used for fetching transactions from the store.
    private var lastToken: NSPersistentHistoryToken?
    
    // MARK: - Init
    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Hyoza")
        
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("Failed to retrieve a persistent store description.")
        }
        if inMemory {
            description.url = URL(fileURLWithPath: "/dev/null")
        }
        
        // Enable persistent history tracking
        /// - Tag: persistentHistoryTracking
//        description.setOption(true as NSNumber,
//                              forKey: NSPersistentHistoryTrackingKey)
//
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        // This sample refreshes UI by consuming store changes via persistent history tracking.
        /// - Tag: viewContextMergeParentChanges
//        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.automaticallyMergesChangesFromParent = true
//        container.viewContext.name = "viewContext"
        /// - Tag: viewContextMergePolicy
//        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        if easyQuestions.count == 0 {
            Task {
                try await fetchQuestion()
            }
        }
    }
    
    // MARK: Save Context
    func saveContext () {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}


extension PersistenceController {
    var fileName: String { "question_samples" }
    var fileExtension: String { "json" }
    
    func fetchQuestion() async throws {
        guard let fileUrl = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
            print("No File..!")
            return
        }
        print("yes file")
        do {
            let data = try Data(contentsOf: fileUrl)
            // Decode the GeoJSON into a data model.
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .secondsSince1970
            let questionPropertiesList = try jsonDecoder.decode([QuestionProperties].self, from: data)
            logger.debug("Received \(questionPropertiesList.count) records.")
            
            // Import the GeoJSON into Core Data.
            logger.debug("Start importing data to the store...")
            try await importQuestions(from: questionPropertiesList)
            logger.debug("Finished importing data.")
            try await setRelationships(with: questionPropertiesList)
            logger.debug("Finished setting relationships.")
            context.refreshAllObjects()
            
        } catch {
            print(":(")
            throw QuestionError.wrongDataFormat(error: error)
        }
    }
}

extension PersistenceController {
    
    /// Creates and configures a private queue context.
    private func newTaskContext() -> NSManagedObjectContext {
        // Create a private queue context.
        /// - Tag: newBackgroundContext
        let taskContext = container.newBackgroundContext()
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        // Set unused undoManager to nil for macOS (it is nil by default on iOS)
        // to reduce resource requirements.
        taskContext.undoManager = nil
        return taskContext
    }
    
    /// Uses `NSBatchInsertRequest` (BIR) to import a JSON dictionary into the Core Data store on a private queue.
    private func importQuestions(from propertiesList: [QuestionProperties]) async throws {
        guard !propertiesList.isEmpty else { return }
        
        let taskContext = newTaskContext()
        // Add name and author to identify source of persistent history changes.
        taskContext.name = "importContext"
        taskContext.transactionAuthor = "importQuestions"
        
        /// - Tag: performAndWait
        try await taskContext.perform {
            // Execute the batch insert.
            /// - Tag: batchInsertRequest
            let batchInsertRequests = self.newBatchInsertRequest(with: propertiesList)
            if let fetchQuestionResult = try? taskContext.execute(batchInsertRequests[0]),
               let fetchAnswerResult = try? taskContext.execute(batchInsertRequests[1]),
               let batchQuestionInsertResult = fetchQuestionResult as? NSBatchInsertResult,
               let batchAnswerInsertResult = fetchAnswerResult as? NSBatchInsertResult,
               let successQuestion = batchQuestionInsertResult.result as? Bool,
               let successAnswer = batchAnswerInsertResult.result as? Bool,
               successQuestion, successAnswer {
                return
            }
            self.logger.debug("Failed to execute batch insert request.")
            throw QuestionError.batchInsertError
        }
        
        logger.debug("Successfully inserted data.")
    }

    private func setRelationships(with propertiesList: [QuestionProperties]) async throws {
        guard !propertiesList.isEmpty else { return }
        
        let taskContext = newTaskContext()
        // Add name and author to identify source of persistent history changes.
        taskContext.name = "setRelationshipsContext"
        taskContext.transactionAuthor = "setRelationships"
        
        try await taskContext.perform {
            for property in propertiesList {
                guard let answer = property.answer else {
                    continue
                }
                let questionRequest: NSFetchRequest<Question> = Question.fetchRequest()
                questionRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [Int64(property.id)])
                let answerRequest: NSFetchRequest<Answer> = Answer.fetchRequest()
                answerRequest.predicate = NSPredicate(format: "answer == %@", argumentArray: [answer])
                
                let questionResults = try? taskContext.fetch(questionRequest)
                let answerResults = try? taskContext.fetch(answerRequest)
                
                questionResults?.first?.answer = answerResults?.first!
            }
            
            if taskContext.hasChanges {
                try taskContext.save()
            }
        }
    }
    
    private func newBatchInsertRequest(with propertiesList: [QuestionProperties]) -> [NSBatchInsertRequest] {
        var index = 0
        var answerIndex = 0
        let total = propertiesList.count

        let batchAnswerInsertRequest = NSBatchInsertRequest(entity: Answer.entity(), dictionaryHandler: { dictionary in
            guard answerIndex < total else {
                return true }
            guard propertiesList[answerIndex].answer != nil else {
                answerIndex += 1
                return false
            }
            dictionary.addEntries(from: propertiesList[answerIndex].answerDictionaryValue)
            answerIndex += 1
            return false
        })
        
        // Provide one dictionary at a time when the closure is called.
        let batchInsertRequest = NSBatchInsertRequest(entity: Question.entity(), dictionaryHandler: { dictionary in
            guard index < total else { return true }
            dictionary.addEntries(from: propertiesList[index].questionDictionaryValue)
            index += 1
            return false
        })
        
        return [batchInsertRequest, batchAnswerInsertRequest]
    }
}
