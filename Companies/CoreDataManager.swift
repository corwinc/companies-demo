//
//  CoreDataManager.swift
//  Companies
//
//  Created by Corwin Crownover on 1/20/18.
//  Copyright © 2018 Corwin LLC. All rights reserved.
//

import CoreData

struct CoreDataManager {
    
    static let shared = CoreDataManager() // will live forever as long as your app is still alive, it's properties will too
    
    let persistentContainer: NSPersistentContainer  = {
        let container = NSPersistentContainer(name: "CompanyModel")
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError("Loading store failed: \(err)")
            }
        }
        
        return container
    }()
    
    func fetchCompanies() -> [Company] {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        
        do {
            let companies = try context.fetch(fetchRequest)
            return companies
        } catch let fetchErr {
            print("Error fetching co:", fetchErr)
            return []
        }
    }
}
