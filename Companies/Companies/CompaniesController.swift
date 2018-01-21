//
//  ViewController.swift
//  Companies
//
//  Created by Corwin Crownover on 1/19/18.
//  Copyright © 2018 Corwin LLC. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController {
    var companies = [Company]() // Creates empty array
    
    @objc private func doWork() {
        CoreDataManager.shared.persistentContainer.performBackgroundTask { (backgroundContext) in
            (0...5).forEach { (value) in
                print(value)
                let company = Company(context: backgroundContext)
                company.name = String(value)
            }
            
            do {
                try backgroundContext.save()
                
                DispatchQueue.main.async {
                    self.companies = CoreDataManager.shared.fetchCompanies()
                    self.tableView.reloadData()
                }
            } catch let err {
                print("Failed to save", err)
            }
        }
    }
    
    @objc private func doUpdates() {
        CoreDataManager.shared.persistentContainer.performBackgroundTask { (backgroundContext) in
            let request:  NSFetchRequest<Company> = Company.fetchRequest()
            
            do {
                let companies = try backgroundContext.fetch(request)
                
                companies.forEach({ (company) in
                    company.name = "A: \(company.name ?? "")"
                })
                
                do {
                    try backgroundContext.save()
                    
                    DispatchQueue.main.async {
                        // Reset will forget all objects you've fetched before
                        CoreDataManager.shared.persistentContainer.viewContext.reset()
                        // You don't want to refetch everything if you simply want to update 1-2 companies
                        self.companies = CoreDataManager.shared.fetchCompanies()
                        // Is there a way to only merge the changes onto the main view context? YES
                        self.tableView.reloadData()
                    }
                } catch let err {
                    print("Failed to save on background", err)
                }
            } catch let err {
                print("Error fetching companies", err)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.companies = CoreDataManager.shared.fetchCompanies()
        
        tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellId")
        
        setupNavigation()
        setupTableViewStyle()
    }
    
    @objc private func handleReset() {
        do {
            try CoreDataManager.shared.deleteCompanies()
            
            // Upon request success
            var indexPathsToRemove = [IndexPath]()
            
            for (index, _) in companies.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathsToRemove.append(indexPath)
            }
            
            // Remove companies from array
            companies.removeAll()
            
            // Remove rows from tableView with animation
            tableView.deleteRows(at: indexPathsToRemove, with: .left)
        } catch let delErr {
            print("Error resetting companies...", delErr)
        }
    }
    
    @objc func handleAddCompany() {
        print("Adding company...")
        
        let createCompanyController = CreateCompanyController()
        
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        
        createCompanyController.delegate = self
        
        present(navController, animated: true, completion: nil)
    }
    
    func setupNavigation() {
        navigationItem.title = "Companies"
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset)),
            UIBarButtonItem(title: "Do Updates", style: .plain, target: self, action: #selector(doUpdates))
        ]
        setupPlusButtonInNavBar(selector: #selector(handleAddCompany))
    }
    
    func setupTableViewStyle() {
        tableView.backgroundColor = .darkBlue
        tableView.tableFooterView = UIView() // blank UIView
        tableView.separatorColor = .white
//        tableView.separatorStyle = .none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

