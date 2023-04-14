//
//  File.swift
//  BitcoinKurs
//
//  Created by Tom Reinhardt on 14.04.23.
//

import Foundation
import CoreData

final class CurrencyChangeEventStorage {
    static let shared = CurrencyChangeEventStorage()
    
    private let persistentContainer: NSPersistentContainer
    
    private init() {
        self.persistentContainer = NSPersistentContainer(name: "Model")
        self.persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("\(error)")
            }
        }
    }
    
    struct CorruptedDataError: Error {}
    
    func loadBatch() throws -> CurrencyChangeEventBatch? {
        let request: NSFetchRequest = CurrencyChangeEventBatchEntity.fetchRequest()
        
        var entities: [CurrencyChangeEventBatchEntity] = []
        
        entities = try persistentContainer.viewContext.fetch(request)
        
        guard let lastBatchEntity = entities.last else {
            return nil
        }
        
        guard let lastUpdated = lastBatchEntity.lastUpdated,
              let changeEvents = lastBatchEntity.changeEvents,
              let currencyString = lastBatchEntity.currency,
              let currency = Currency(rawValue: currencyString) else {
            throw CorruptedDataError()
        }
        
        var domainModels: [CurrencyChangeEvent] = []
        
        for event in changeEvents {
            guard let event = event as? CurrencyChangeEventEntity,
                  let date = event.date else {
                throw CorruptedDataError()
            }
            
            let domainModelEvent = CurrencyChangeEvent(date: date, factor: event.value)
            domainModels.append(domainModelEvent)
        }
        
        let batch = CurrencyChangeEventBatch(
            lastUpdated: lastUpdated,
            currency: currency,
            changeEvents: domainModels
        )
        
        return batch
    }
    
    func saveBatch(batch: CurrencyChangeEventBatch) {
        let changeEventEntities = batch.changeEvents.map { event in
            let entity = CurrencyChangeEventEntity(context: persistentContainer.viewContext)
            entity.date = event.date
            entity.value = event.factor
            
            return entity
        }
        
        let batchEntity = CurrencyChangeEventBatchEntity(context: persistentContainer.viewContext)
        batchEntity.changeEvents = NSOrderedSet(array: changeEventEntities)
        batchEntity.lastUpdated = batch.lastUpdated
        batchEntity.currency = batch.currency.rawValue
        
        saveContext()
    }
    
    private func saveContext() {
        let context = persistentContainer.viewContext
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
