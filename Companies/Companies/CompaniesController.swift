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
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
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

