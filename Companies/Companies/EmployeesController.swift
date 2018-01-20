//
//  EmployeesController.swift
//  Companies
//
//  Created by Corwin Crownover on 1/20/18.
//  Copyright © 2018 Corwin LLC. All rights reserved.
//

import UIKit

class EmployeesController: UITableViewController {
    var company: Company?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company?.name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .yellow
    }
}
