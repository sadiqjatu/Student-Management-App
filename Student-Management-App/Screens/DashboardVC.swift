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
    let sectionDatasource: [[UIColor]] = [ [.systemYellow, .systemRed],
                                           [.systemRed, .systemYellow, .systemRed],
                                           [.systemCyan, .systemRed]
    ]
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
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createDashboardLayout())
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        
        collectionView.register(TopCardCell.self, forCellWithReuseIdentifier: TopCardCell.reuseID)
        collectionView.register(MetricCell.self, forCellWithReuseIdentifier: MetricCell.reuseID)
        collectionView.register(AttentionCell.self, forCellWithReuseIdentifier: AttentionCell.reuseID)
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    
    func createDashboardLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnviroment) -> NSCollectionLayoutSection? in
            
            switch sectionIndex {
            case 0: // Section 0: Top cards (2 horizontal items)
                let itemSize  = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item      = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120))
                let group     = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section   = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                
                return section
                
            case 1: // Section 1: Metrics (3 horizontal items)
                let itemSize  = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.333), heightDimension: .fractionalHeight(1.0))
                let item      = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80))
                let group     = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                return NSCollectionLayoutSection(group: group)
                
            default: // Section 2: Attention required list (Vertical items)
                let itemSize  = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item      = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
                let group     = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                return NSCollectionLayoutSection(group: group)
            }
        }
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
            cell.backgroundColor = sectionDatasource[indexPath.section][indexPath.item]
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MetricCell.reuseID, for: indexPath) as! MetricCell
            cell.backgroundColor = sectionDatasource[indexPath.section][indexPath.item]
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AttentionCell.reuseID, for: indexPath) as! AttentionCell
            cell.backgroundColor = sectionDatasource[indexPath.section][indexPath.item]
            return cell
        }
    }
}
