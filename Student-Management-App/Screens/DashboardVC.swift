//
//  DashboardVC.swift
//  Student-Management-App
//
//  Created by Sadiq Jatu on 04/07/26.
//

import UIKit

class DashboardVC: UIViewController {
    
    let dateLabel = SMTertitaryTitleLabel(textAlignment: .left, fontSize: 18)
    
    var collectionView: UICollectionView!
    let sectionDatasource: [[String]] = [ ["142", "94.2%"],
                                           ["134", "6", "2"],
                                           ["4", "D"]
    ]
    
    let attentionStudents: [String] = ["Alex Jones", "Jane Smith"]
    let padding: CGFloat = 16

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureDateLabel()
        configureCollectionView()
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemGray5
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func configureDateLabel() {
        view.addSubview(dateLabel)
        dateLabel.text = "June 24, 2026"
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createDashboardLayout())
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate   = self
        collectionView.backgroundColor = .clear
        
        collectionView.register(TopCardCell.self, forCellWithReuseIdentifier: TopCardCell.reuseID)
        collectionView.register(MetricCell.self, forCellWithReuseIdentifier: MetricCell.reuseID)
        collectionView.register(AttentionCell.self, forCellWithReuseIdentifier: AttentionCell.reuseID)
        collectionView.register(HeaderCell.self, forSupplementaryViewOfKind: HeaderCell.reuseID, withReuseIdentifier: HeaderCell.reuseID)
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}


extension DashboardVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0: return 2    //Total roster, Total attendance
        case 1: return 3    //Present, Absent, Tardy
        case 2: return 2
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopCardCell.reuseID, for: indexPath) as! TopCardCell
            
            switch indexPath.item {
            case 0:
                cell.set(type: .roster, value: sectionDatasource[indexPath.section][indexPath.item])
            default:
                cell.set(type: .attendance, value: sectionDatasource[indexPath.section][indexPath.item])
            }
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MetricCell.reuseID, for: indexPath) as! MetricCell
            
            switch indexPath.item {
            case 0:
                cell.set(type: .present, value: sectionDatasource[indexPath.section][indexPath.item])
            case 1:
                cell.set(type: .absent, value: sectionDatasource[indexPath.section][indexPath.item])
            default:
                cell.set(type: .tardy, value: sectionDatasource[indexPath.section][indexPath.item])
            }
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AttentionCell.reuseID, for: indexPath) as! AttentionCell
            
            switch indexPath.item {
            case 0:
                cell.set(type: .attendance, studentName: "Alex Jones", status: "\(sectionDatasource[indexPath.section][indexPath.item]) Absences")
            default:
                cell.set(type: .grade, studentName: "Jane Smith", status: "\(sectionDatasource[indexPath.section][indexPath.item]) Average")
            }
            
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == HeaderCell.reuseID {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCell.reuseID, for: indexPath) as! HeaderCell
            
            return cell
        }
        
        return UICollectionReusableView()
    }
}


extension DashboardVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            let totalItems       = collectionView.numberOfItems(inSection: indexPath.section)
            guard let metricCell = cell as? MetricCell else { return }
            
            metricCell.containerView.layer.cornerRadius  = 0
            metricCell.containerView.layer.maskedCorners = []
            
            if indexPath.item == 0 {
                metricCell.containerView.layer.cornerRadius  = 18
                metricCell.containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            } else if indexPath.item == totalItems - 1 {
                metricCell.containerView.layer.cornerRadius  = 18
                metricCell.containerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            }
            
            metricCell.containerView.clipsToBounds = true
        }
        
        
        if indexPath.section == 2 {
            let totalItems          = collectionView.numberOfItems(inSection: indexPath.section)
            guard let attentionCell = cell as? AttentionCell else { return }
            
            attentionCell.containerView.layer.cornerRadius  = 0
            attentionCell.containerView.layer.maskedCorners = []
            
            if indexPath.row == 0 {
                attentionCell.containerView.layer.cornerRadius  = 18
                attentionCell.containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            } else if indexPath.row == totalItems - 1 {
                attentionCell.containerView.layer.cornerRadius  = 18
                attentionCell.containerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            }
            
            attentionCell.containerView.clipsToBounds = true
        }
    }
}
