//
//  StudentsVC.swift
//  Student-Management-App
//
//  Created by Sadiq Jatu on 04/07/26.
//

import UIKit
import CoreData

class StudentsVC: UIViewController {
    
    let searchController            = UISearchController(searchResultsController: nil)
    let tableView                   = UITableView()
        
    let context                     = CoreDataManager.shared.context
    var allStudents: [Student]      = []
    var filteredStudents: [Student] = []
    
    let padding: CGFloat            = 16
    var isSearching                 = false
      
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureSearchController()
        configureTableView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAllStudents()
    }

    
    func configureViewController() {
        view.backgroundColor = .systemGray5
        
        let addPersonButton       = UIButton(type: .system)
        addPersonButton.setImage(Icons.personAdd, for: .normal)
        addPersonButton.tintColor = Colors.blue
        addPersonButton.addTarget(self, action: #selector(addPersonButtonPressed), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addPersonButton)
    }
    
    
    func configureSearchController() {
        searchController.searchResultsUpdater      = self                   // 1. Tells the controller to send text updates to this VC
        searchController.obscuresBackgroundDuringPresentation = false   //2. Stop the screen from dimming while searching
        searchController.searchBar.placeholder     = "Search name..."
        navigationItem.searchController            = searchController
        definesPresentationContext                 = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.dataSource      = self
        tableView.delegate        = self
        tableView.backgroundColor = .clear
        tableView.rowHeight       = 70
        tableView.showsVerticalScrollIndicator = false
        tableView.register(StudentCell.self, forCellReuseIdentifier: StudentCell.reuseId)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding)
        ])
    }
    
    //MARK: - Core data fetch method
    
    func fetchAllStudents() {
        allStudents = CoreDataManager.shared.fetchAllStudents()
        tableView.reloadData()
    }
    
    
    @objc func addPersonButtonPressed() {
        print("Add person button pressed")
        let addStudentVC      = AddStudentVC()
        addStudentVC.delegate = self
        
        let navController = UINavigationController(rootViewController: addStudentVC)
        navigationController?.present(navController, animated: true)
    }
}


extension StudentsVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            isSearching = false
            tableView.reloadData()
            return
        }
        
        isSearching = true
        
        filteredStudents = allStudents.filter({ student in
            (student.firstName ?? "").lowercased().contains(searchText.lowercased()) ||
            (student.lastName ?? "").lowercased().contains(searchText.lowercased()) ||
            ("\(student.firstName ?? "") \(student.lastName ?? "")").lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
}


extension StudentsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredStudents.count : allStudents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StudentCell.reuseId, for: indexPath) as! StudentCell
        
        let student = isSearching ? filteredStudents[indexPath.row] : allStudents[indexPath.row]
        
        cell.studentNameLabel.text = "\(student.firstName ?? "Unknown") \(student.lastName ?? "")"
        cell.idLabel.text          = "ID: \(student.id ?? "N/A")"
        cell.gradeLabel.text       = "• Grade \(student.gradeLevel)"
        
        return cell
    }
}


extension StudentsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let totalStudents = tableView.numberOfRows(inSection: 0)
        
        guard let studentcell = cell as? StudentCell else { return }
        
        if indexPath.row == 0 {
            studentcell.containerView.layer.cornerRadius  = 18
            studentcell.containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if indexPath.row == totalStudents - 1 {
            studentcell.containerView.layer.cornerRadius  = 18
            studentcell.containerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            studentcell.containerView.layer.cornerRadius  = 0
            studentcell.containerView.layer.maskedCorners = []
        }
        
        if totalStudents == 1 {
            studentcell.containerView.layer.cornerRadius  = 18
            studentcell.containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        
        studentcell.containerView.clipsToBounds = true
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? StudentCell else { return }
        cell.containerView.backgroundColor = .systemGray5
        
        UIView.animate(withDuration: 0.5) {
            cell.containerView.backgroundColor = .systemBackground
        }
        
        //get current student either from filtered array or original array
        let student = isSearching ? filteredStudents[indexPath.row] : allStudents[indexPath.row]
        
        //inject the student object to the initializer 
        let studentDetailVC = StudentDetailVC(selectedStudent: student)
        navigationController?.pushViewController(studentDetailVC, animated: true)
    }
}


extension StudentsVC: AddStudentVCDelegate {
    
    func didTapSaveButton() {
        self.fetchAllStudents()
    }
}
