//
//  EmployeesController.swift
//  Companies
//
//  Created by Corwin Crownover on 1/20/18.
//  Copyright © 2018 Corwin LLC. All rights reserved.
//

import UIKit
import CoreData

class EmployeesController: UITableViewController, CreateEmployeeControllerDelegate {
    func didAddEmployee(employee: Employee) {
        employees.append(employee)
        tableView.reloadData()
    }
    
    let employeeCellId = "employeeCell"
    
    var company: Company?
    
    var employees = [Employee]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company?.name
    }
    
    private func fetchEmployees() {
        // Must use .allObjects to cast NSSet as an array; employees is instantiated as an array [Employees]
        guard let companyEmployees = company?.employees?.allObjects as? [Employee] else { return }
        self.employees = companyEmployees
        
        // FETCH ALL EMPLOYEES REQUEST PRIOR TO COMPANY:EMPLOYEES RELATIONSHIP SETUP
//        let context = CoreDataManager.shared.persistentContainer.viewContext
//        let request = NSFetchRequest<Employee>(entityName: "Employee")
//
//        do {
//            let employees = try context.fetch(request)
//            // Must manually set controller's employees list equal to fetched employees
//            self.employees = employees
////            employees.forEach{print("Employee name:", $0.name ?? "")}
//        } catch let err {
//            print("Failed to fetch employees", err)
//        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: employeeCellId, for: indexPath)
        
        let employee = employees[indexPath.row]
        cell.textLabel?.text = employee.name
        
        if let taxId = employee.employeeInformation?.taxId {
            cell.textLabel?.text = "\(employee.name ?? "")     \(taxId)"
        }
        
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        cell.backgroundColor = .teal
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPlusButtonInNavBar(selector: #selector(handleAdd))
        
        fetchEmployees()
        
        tableView.backgroundColor = .darkBlue
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: employeeCellId)
    }
    
    @objc private func handleAdd() {
        print("adding...")
        
        let createEmployeeController = CreateEmployeeController()
        createEmployeeController.delegate = self
        createEmployeeController.company = company
        let navController = UINavigationController(rootViewController: createEmployeeController)
        
        present(navController, animated: true, completion: nil)
    }
}
