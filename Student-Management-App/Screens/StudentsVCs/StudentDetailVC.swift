//
//  StudentDetailVC.swift
//  Student-Management-App
//
//  Created by Sadiq Jatu on 13/07/26.
//

import UIKit

class StudentDetailVC: UIViewController {
    
    var selectedStudent: Student!
    var collectionView: UICollectionView!       //Creates the collection view
    var sectionDataSource: [[UIColor]] = [[.yellow], [.blue, .red, .blue], [.black, .white, .gray]]
    
    
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
    
    
    func configureViewController() {
        view.backgroundColor = .systemGray5
        
        guard let selectedStudent = selectedStudent else { return }
        print(selectedStudent.firstName!, selectedStudent.lastName!)
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
        case 2: return 3
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StudentProfileCell.reuseID, for: indexPath) as! StudentProfileCell
            print(indexPath.item)
            cell.backgroundColor = sectionDataSource[indexPath.section][indexPath.item]
            
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StudentMetricCell.reuseID, for: indexPath) as! StudentMetricCell
            print(indexPath.item)
            cell.backgroundColor = sectionDataSource[indexPath.section][indexPath.item]
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StudentLogCell.reuseID, for: indexPath) as! StudentLogCell
            print(indexPath.item)
            cell.backgroundColor = sectionDataSource[indexPath.section][indexPath.item]
            
            return cell
        }
    }
}


extension StudentDetailVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
