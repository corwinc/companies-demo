//
//  CreateCompanyController.swift
//  Companies
//
//  Created by Corwin Crownover on 1/19/18.
//  Copyright © 2018 Corwin LLC. All rights reserved.
//

import UIKit

class CreateCompanyController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Create Company"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        view.backgroundColor = .darkBlue
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}
