//
//  EmployeesController.swift
//  Companies
//
//  Created by Corwin Crownover on 1/20/18.
//  Copyright © 2018 Corwin LLC. All rights reserved.
//

import UIKit
import CoreData

class IndentedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let customRect = UIEdgeInsetsInsetRect(rect, insets)
        super.drawText(in: customRect)
    }
}

class EmployeesController: UITableViewController, CreateEmployeeControllerDelegate {
    func didAddEmployee(employee: Employee) {
        fetchEmployees()
        tableView.reloadData()
    }
    
    let employeeCellId = "employeeCell"
    
    var company: Company?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company?.name
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentedLabel()
        if section == 0 {
            label.text = EmployeeType.Executive.rawValue
        } else if section == 1 {
            label.text = EmployeeType.SeniorManagement.rawValue
        } else {
            label.text = EmployeeType.Staff.rawValue
        }
        label.backgroundColor = .lightBlue
        label.textColor = .darkBlue
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    var allEmployees = [[Employee]]()
    let employeeTypes = [
        EmployeeType.Executive.rawValue,
        EmployeeType.SeniorManagement.rawValue,
        EmployeeType.Staff.rawValue
    ]
    
    private func fetchEmployees() {
        // Must use .allObjects to cast NSSet as an array; employees is instantiated as an array [Employees]
        guard let companyEmployees = company?.employees?.allObjects as? [Employee] else { return }
        
        employeeTypes.forEach { (type) in
            allEmployees.append(companyEmployees.filter{ $0.type == type })
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allEmployees.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEmployees[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: employeeCellId, for: indexPath)
        let employee = allEmployees[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = employee.name
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyy"

        if let birthday = employee.employeeInformation?.birthday {
            let birthdayDate = dateFormatter.string(from: birthday)
            cell.textLabel?.text = "\(employee.name ?? "")     \(birthdayDate)"
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
        let createEmployeeController = CreateEmployeeController()
        createEmployeeController.delegate = self
        createEmployeeController.company = company
        let navController = UINavigationController(rootViewController: createEmployeeController)
        
        present(navController, animated: true, completion: nil)
    }
}
