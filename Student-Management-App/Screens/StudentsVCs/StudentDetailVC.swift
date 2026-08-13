//
//  StudentDetailVC.swift
//  Student-Management-App
//
//  Created by Sadiq Jatu on 13/07/26.
//

import UIKit

class StudentDetailVC: UIViewController {
    
    let currentYear = Calendar.current.component(.year, from: Date())
    
    var selectedStudent: Student!
    var collectionView: UICollectionView!       //Creates the collection view
    
    var attendanceData: [AttendanceRecord]  = []
    var gradeData:      [Grade]             = []
    
    var selectedSegmentControlIndex = 0
    
    init(selectedStudent: Student) {
        super.init(nibName: nil, bundle: nil)
        self.selectedStudent = selectedStudent
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureCollectionView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadData()
    }
    
    
    private func loadData() {
        //Fetch all attendance data for selected student
        attendanceData = CoreDataManager.shared.fetchRecords(for: selectedStudent)
        
        //Fetch all the grades for selected student
        gradeData     = CoreDataManager.shared.fetchAllGrades(for: selectedStudent)
        
        collectionView.reloadData()
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemGray5
    }
    
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createStudentDetailLayout())
        
        //setting up properties
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource       = self
        collectionView.delegate         = self
        collectionView.backgroundColor  = .clear
        
        //registering the cells
        collectionView.register(StudentProfileCell.self, forCellWithReuseIdentifier: StudentProfileCell.reuseID)
        collectionView.register(StudentMetricCell.self, forCellWithReuseIdentifier: StudentMetricCell.reuseID)
        collectionView.register(StudentLogCell.self, forCellWithReuseIdentifier: StudentLogCell.reuseID)
        collectionView.register(StudentSegmentControlCell.self, forSupplementaryViewOfKind: StudentSegmentControlCell.reuseID, withReuseIdentifier: StudentSegmentControlCell.reuseID)
        
        //add to to the view
        view.addSubview(collectionView)
        
        //use auto layout constraints to pin the collection view
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}


extension StudentDetailVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0: return 1
        case 1: return 3
        case 2: return selectedSegmentControlIndex == 0 ? attendanceData.count : gradeData.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StudentProfileCell.reuseID, for: indexPath) as! StudentProfileCell
            
            cell.studentNameLabel.text = "\(selectedStudent.firstName ?? "N/A") \(selectedStudent.lastName ?? "")"
            let farewellYear           = Int16(currentYear) + (Int16(12) - selectedStudent.gradeLevel)
            cell.classNameLabel.text   = "Class of \(farewellYear)"
            
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StudentMetricCell.reuseID, for: indexPath) as! StudentMetricCell
            
            switch indexPath.item {
                
            case 0:
                cell.set(type: .absences, value: "\(selectedStudent.absencesCount)")
            case 1:
                cell.set(
                    type: .avgGrade,
                    value: "\(selectedStudent.currentGradePercentage.formatted(.number.precision(.fractionLength(1))))%"
                )
            case 2:
                cell.set(type: .gradeLevel, value: "Gr \(selectedStudent.gradeLevel)")
            default:
                return UICollectionViewCell()
            }
            
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StudentLogCell.reuseID, for: indexPath) as! StudentLogCell
            
            if selectedSegmentControlIndex == 0 {
                let record = attendanceData[indexPath.item]
                
                switch record.status {
                case "P":
                    cell.set(type: .present, value: record.date ?? "N/A", testName: nil, maxPoints: nil)
                case "A":
                    cell.set(type: .absent, value: record.date ?? "N/A", testName: nil, maxPoints: nil)
                default:
                    cell.set(type: .tardy, value: record.date ?? "N/A", testName: nil, maxPoints: nil)
                }
            } else {
                let gradeRecord = gradeData[indexPath.item]
                
                cell.set(
                    type: .grade,
                    value: String(gradeRecord.earnedPoints),
                    testName: gradeRecord.parentAssignment?.title ?? "N/A",
                    maxPoints: String(gradeRecord.parentAssignment?.maxPoints ?? 0)
                )
            }
            
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == StudentSegmentControlCell.reuseID {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: StudentSegmentControlCell.reuseID, withReuseIdentifier: StudentSegmentControlCell.reuseID, for: indexPath) as! StudentSegmentControlCell
        
            cell.onSegmentChanged = { [weak self] selectedIndex in
                guard let self = self else { return }
                print("Selected Index in VC: \(selectedIndex)")
                self.selectedSegmentControlIndex = selectedIndex
                self.collectionView.reloadData()
            }
            
            return cell
        }
        
        return UICollectionReusableView()
    }
}


extension StudentDetailVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            let totalItems = collectionView.numberOfItems(inSection: indexPath.section)
            guard let studentMetricCell = cell as? StudentMetricCell else { return }
            
            studentMetricCell.layer.cornerRadius  = 0
            studentMetricCell.layer.maskedCorners = []
            
            if indexPath.item == 0 {
                studentMetricCell.layer.cornerRadius  = 18
                studentMetricCell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            } else if indexPath.item == totalItems - 1 {
                studentMetricCell.layer.cornerRadius  = 18
                studentMetricCell.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            }
            
            studentMetricCell.clipsToBounds = true
        }
        
        if indexPath.section == 2 {
            let totalItems = collectionView.numberOfItems(inSection: indexPath.section)
            guard let studentLogCell = cell as? StudentLogCell else { return }
            
            studentLogCell.layer.cornerRadius  = 0
            studentLogCell.layer.maskedCorners = []
            
            if indexPath.item == 0 {
                studentLogCell.layer.cornerRadius  = 18
                studentLogCell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            } else if indexPath.item == totalItems - 1{
                studentLogCell.layer.cornerRadius  = 18
                studentLogCell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            }
            
            if totalItems == 1 {
                studentLogCell.layer.cornerRadius = 18
                studentLogCell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            }
            
            studentLogCell.clipsToBounds = true
        }
    }
}
