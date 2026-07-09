//
//  StudentsVC.swift
//  Student-Management-App
//
//  Created by Sadiq Jatu on 04/07/26.
//

import UIKit

class StudentsVC: UIViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
    }

    
    func configureViewController() {
        view.backgroundColor = .systemGray5
        
        let addPersonButton       = UIButton(type: .system)
        addPersonButton.setImage(Icons.personAdd, for: .normal)
        addPersonButton.tintColor = Colors.blue
        addPersonButton.addTarget(self, action: #selector(addPersonButtonPressed), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addPersonButton)
    }
    
    
    @objc func addPersonButtonPressed() {
        print("Add person button pressed")
    }
    
    
    func configureSearchController() {
        
    }
}
