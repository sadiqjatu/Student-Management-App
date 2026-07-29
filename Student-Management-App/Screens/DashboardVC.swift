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
    
    var topCardData:   [TopCardData]     = []
    var metricData:    [MetricData]      = []
    var attentionData: [AttentionRecord] = []
    
    let padding: CGFloat = 16

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureCollectionView()
        loadMockData()
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemGray5
        navigationController?.navigationBar.prefersLargeTitles = true
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
        collectionView.register(DateCell.self, forSupplementaryViewOfKind: DateCell.reuseID, withReuseIdentifier: DateCell.reuseID)
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    private func loadMockData() {
        
        topCardData   = [
            TopCardData(type: .roster, value: "142"),
            TopCardData(type: .attendance, value: "94.2%")
        ]
        
        metricData    = [
            MetricData(type: .present, value: "134"),
            MetricData(type: .absent, value: "6"),
            MetricData(type: .tardy, value: "2")
        ]
        
        attentionData = [
            AttentionRecord(studentName: "Alex Jones", value: "4", issueType: .attendance),
            AttentionRecord(studentName: "Jane Smith", value: "D", issueType: .grade),
            AttentionRecord(studentName: "Sadiq Jatu", value: "8", issueType: .attendance)
        ]
        
        collectionView.reloadData()
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
        case 2: return attentionData.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopCardCell.reuseID, for: indexPath) as! TopCardCell
            let topCardRecord = topCardData[indexPath.item]
            
            switch topCardRecord.type {
            case .attendance:
                cell.set(type: .attendance, value: topCardRecord.value)
            case .roster:
                cell.set(type: .roster, value: topCardRecord.value)
            }
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MetricCell.reuseID, for: indexPath) as! MetricCell
            let metricRecord = metricData[indexPath.item]
            
            switch metricRecord.type {
            case .present:
                cell.set(type: .present, value: metricRecord.value)
            case .absent:
                cell.set(type: .absent, value: metricRecord.value)
            case .tardy:
                cell.set(type: .tardy, value: metricRecord.value)
            }
            return cell
            
        default:
            let cell   = collectionView.dequeueReusableCell(withReuseIdentifier: AttentionCell.reuseID, for: indexPath) as! AttentionCell
            let record = attentionData[indexPath.item]
            
            switch record.issueType {
            case .attendance:
                cell.set(type: .attendance, studentName: record.studentName, status: "\(record.value) Absences")
            case .grade:
                cell.set(type: .grade, studentName: record.studentName, status: "\(record.value) Average")
            }
            
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == HeaderCell.reuseID {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCell.reuseID, for: indexPath) as! HeaderCell
            
            return cell
        }
        
        if kind == DateCell.reuseID {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: DateCell.reuseID, withReuseIdentifier: DateCell.reuseID, for: indexPath) as! DateCell
            
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
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 2 {
            guard let cell = collectionView.cellForItem(at: indexPath) as? AttentionCell else { return }
            cell.containerView.backgroundColor = .systemGray5
            
            UIView.animate(withDuration: 0.5) {
                cell.containerView.backgroundColor = .systemBackground
            }
        }
    }
}
