//
//  DataService.swift
//  DemoFetchedResultsInCoreData
//
//  Created by Tran Ngoc Nam on 5/11/18.
//  Copyright © 2018 Tran Ngoc Nam. All rights reserved.
//

import Foundation
import CoreData

class DataService {
    
    static let shared: DataService = DataService()
    
    private var _fetchedResultsController: NSFetchedResultsController<Person>? = nil
    
    var fetchedResultsController: NSFetchedResultsController<Person> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        
        fetchRequest.fetchBatchSize = 20
        
        let namePerson = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [namePerson]
        
        _fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: AppDelegate.context, sectionNameKeyPath: nil, cacheName: "Master")
        
        do {
            try _fetchedResultsController?.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    
    func saveToCoreData() {
        let context = _fetchedResultsController?.managedObjectContext
        do {
            try context?.save()
            print("Core Data Saved")
        } catch let error as NSError {
            print("\(error.userInfo)")
        }
    }
    

}
