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
    
    func deleteCompanies() {
        let context = persistentContainer.viewContext
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        do {
            try context.execute(batchDeleteRequest)
        } catch let err {
            print("err resetting companies...", err)
        }
    }
    
    func createEmployee(employeeName: String, company: Company) -> (Employee?, Error?) {
        let context = persistentContainer.viewContext
        
        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee
        employee.setValue(employeeName, forKey: "name")
        
        employee.company = company
        
        // Check company entity & relationship is setup property
//        let company = Company(context: context)
//        company.employees // employees is NSSet which is correct!
//        employee.company // company is Company? which is correct! Can only have a single company
        
        let employeeInformation = NSEntityDescription.insertNewObject(forEntityName: "EmployeeInformation", into: context) as! EmployeeInformation
        // Use .taxId b/c safer than setValue in case taxId key changes; can do it only b/c employeeInfo is casted as! EmployeeInformation
        employeeInformation.taxId = "456"
//        employeeInformation.setValue("456", forKey: "taxId")
        
        employee.employeeInformation = employeeInformation
        
        do {
            try context.save()
            return (employee, nil) // do not have to return nil here if Error is optional (Error)
        } catch let err {
            print("Error saving employee:", err)
            return (nil, err)
        }
    }

}
