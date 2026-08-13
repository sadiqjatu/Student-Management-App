//
//  GradebookVC.swift
//  Student-Management-App
//
//  Created by Sadiq Jatu on 04/07/26.
//

import UIKit

//struct AssignmnetRecord {
//    let title: String?
//    let dueDate: String?
//    let weight: String?
//    let avgScore: String?
//}

class GradebookVC: UIViewController {
    
    let tableView                 = UITableView(frame: .zero, style: .insetGrouped)
    var assignments: [Assignment] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureTableView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadAssignments()
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemGray5
        
        let addAssignmentButton = UIButton(type: .system)
        addAssignmentButton.setImage(Icons.assignmentAdd, for: .normal)
        addAssignmentButton.tintColor = Colors.blue
        addAssignmentButton.addTarget(self, action: #selector(addAssignmentButtonPressed), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addAssignmentButton)
    }
    
    
    func loadAssignments() {
        
        //Fetch all the assignments from the database
        assignments = CoreDataManager.shared.fetchAllAssignments()
        print(assignments.count)
        
        tableView.reloadData()
    }
    
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.dataSource      = self
        tableView.delegate        = self
        tableView.rowHeight       = 80
        tableView.backgroundColor = .clear
        tableView.register(AssignmentCell.self, forCellReuseIdentifier: AssignmentCell.reuseId)
        
        //Pin the table view using auto layout constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    
    //Create addAssignment objective c function method
    @objc func addAssignmentButtonPressed() {
        //Present AddAssignmentvc modally, also wrap it inside a navigation controller
        print("Add assignment pressed")
        let addAssignmentVC      = AddAssignmentVC()
        addAssignmentVC.delegate = self
        
        let navController   = UINavigationController(rootViewController: addAssignmentVC)
        navigationController?.present(navController, animated: true)
    }
}


//Create an extension and conform to the UITable view data source method
extension GradebookVC: UITableViewDataSource {
    //Implement numberOfRows function and return the count of array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignments.count
    }
    
    
    //Implement cellForRow function and set properties to the cell then eventually return the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AssignmentCell.reuseId, for: indexPath) as! AssignmentCell
        
        let assignment = assignments[indexPath.row]
        cell.assignmentNameLabel.text = "\(assignment.title ?? "N/A")"
        cell.dueDateLabel.text        = "Due \(assignment.dueDate ?? "N/A")"
        cell.weightLabel.text         = " • Weight: \(assignment.weight)%"
        cell.avgScoreLabel.text       = "\(assignment.avgScore.formatted(.number.precision(.fractionLength(1))))% Avg"
        
        return cell
    }
}


extension GradebookVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? AssignmentCell else { return }
        cell.containerView.backgroundColor     = .systemGray5
        
        UIView.animate(withDuration: 0.5) {
            cell.containerView.backgroundColor = .systemBackground
        }
        
        //Get assignment from array
        let assignment     = assignments[indexPath.row]
        
        //Inject the assignment object into the init
        let gradingEntryVC = GradingEntryVC(selectedAssignment: assignment)
        navigationController?.pushViewController(gradingEntryVC, animated: true)
    }
}

extension GradebookVC: AddAssignmentVCDelegate {
    
    func didTapSaveButton() {
        loadAssignments()
    }
}
