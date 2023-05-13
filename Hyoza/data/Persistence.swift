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
    
    let container: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    /// A peristent history token used for fetching transactions from the store.
    private var lastToken: NSPersistentHistoryToken?
    
    // MARK: - Init
    private init() {
        container = NSPersistentContainer(name: "Hyoza")
        
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("Failed to retrieve a persistent store description.")
        }
        
        description.url = URL(fileURLWithPath: "/dev/null")
        
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
        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.name = "viewContext"
        /// - Tag: viewContextMergePolicy
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        Task {
            try await fetchQuestion()
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
            print("error1")
            // Decode the GeoJSON into a data model.
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .secondsSince1970
            let questionPropertiesList = try jsonDecoder.decode([QuestionProperties].self, from: data)
            logger.debug("Received \(questionPropertiesList.count) records.")
            
            // Import the GeoJSON into Core Data.
            logger.debug("Start importing data to the store...")
            try await importQuestions(from: questionPropertiesList)
            logger.debug("Finished importing data.")
            
            let context = container.viewContext
            context.refreshAllObjects()
            
            for questionProperties in questionPropertiesList {
                dump(questionProperties)
                guard let answer = questionProperties.answer else {
                    continue
                }
                let questionRequest: NSFetchRequest<Question> = Question.fetchRequest()
                questionRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [Int64(questionProperties.id)])
                let answerRequest: NSFetchRequest<Answer> = Answer.fetchRequest()
                answerRequest.predicate = NSPredicate(format: "answer == %@", argumentArray: [answer])
                
                let questionResults = try context.fetch(questionRequest)
                let allAnswers = try context.fetch(Answer.fetchRequest())
                let answerResults = try context.fetch(answerRequest)
                
                print(questionResults)
                print(allAnswers)
                print(answerResults)
                questionResults.first!.answer = answerResults.first!
            }
            
            if context.hasChanges {
                try context.save()
            }
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

    private func newBatchInsertRequest(with propertyList: [QuestionProperties]) -> [NSBatchInsertRequest] {
        var index = 0
        var answerIndex = 0
        let total = propertyList.count

        let batchAnswerInsertRequest = NSBatchInsertRequest(entity: Answer.entity(), dictionaryHandler: { dictionary in
            guard answerIndex < total else {
                return true }
            guard propertyList[answerIndex].answer != nil else {
                answerIndex += 1
                return false
            }
            dictionary.addEntries(from: propertyList[answerIndex].answerDictionaryValue)
            answerIndex += 1
            return false
        })
        
        // Provide one dictionary at a time when the closure is called.
        let batchInsertRequest = NSBatchInsertRequest(entity: Question.entity(), dictionaryHandler: { dictionary in
            guard index < total else { return true }
            dictionary.addEntries(from: propertyList[index].questionDictionaryValue)
            index += 1
            return false
        })
        
        
        return [batchInsertRequest, batchAnswerInsertRequest]
    }
}
