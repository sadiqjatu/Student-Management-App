//
//  UIHelper.swift
//  Student-Management-App
//
//  Created by Sadiq Jatu on 07/07/26.
//

import UIKit

enum UIHelper {
    
    static func createDashboardLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnviroment) -> NSCollectionLayoutSection? in
            
            switch sectionIndex {
            case 0: // Section 0: Top cards (2 horizontal items)
                let itemSize  = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
                let item      = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(140))
                let group     = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.contentInsets    = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
                group.interItemSpacing = .fixed(16)
                
                let section   = NSCollectionLayoutSection(group: group)
//                section.orthogonalScrollingBehavior = .continuous
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(34))
                let header     = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: DateCell.reuseID, alignment: .top)
                header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
                section.boundarySupplementaryItems.append(header)
                
                return section
                
            case 1: // Section 1: Metrics (3 horizontal items)
                let itemSize  = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.333), heightDimension: .fractionalHeight(1.0))
                let item      = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
                let group     = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
                group.interItemSpacing = .fixed(2)
                
                let section   = NSCollectionLayoutSection(group: group)
                
                return section
                
            default: // Section 2: Attention required list (Vertical items)
                let itemSize  = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item      = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
                let group     = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                let section   = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
                section.interGroupSpacing = 2
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
                let header     = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: HeaderCell.reuseID, alignment: .top)
                
                section.boundarySupplementaryItems.append(header)
                
                return section
            }
        }
    }
    
    
    static func createStudentDetailLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnviroment in
            
            switch sectionIndex {
            case 0: //Section 0: Profile Card (1 item)
                let itemSize  = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item      = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(220))
                let group     = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
                
                let section   = NSCollectionLayoutSection(group: group)
                
                return section
                
            case 1: // Section 1: Metric cards (3 items)
                let itemSize  = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.333), heightDimension: .fractionalHeight(1.0))
                let item      = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(110))
                let group     = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                group.contentInsets    = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 16, trailing: 16)
                group.interItemSpacing = .fixed(2)
                
                let section   = NSCollectionLayoutSection(group: group)
                
                return section
                
            default: //Section 2: Log cells ( n number of items)
                let itemSize  = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item      = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
                let group     = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                let section   = NSCollectionLayoutSection(group: group)
                section.contentInsets     = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 8, trailing: 16)
                section.interGroupSpacing = 2
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(45))
                let header     = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: StudentSegmentControlCell.reuseID, alignment: .top)
                
                section.boundarySupplementaryItems.append(header)
                
                return section
            }
        }
    }
    
    
    static func createTertiaryLabel(label: String, textAlignment: NSTextAlignment) -> SMTertitaryTitleLabel {
        let textLabel  = SMTertitaryTitleLabel(textAlignment: textAlignment, fontSize: 16)
        textLabel.text = label
        
        return textLabel
    }
}
