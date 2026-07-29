//
//  StudentMetricCell.swift
//  Student-Management-App
//
//  Created by Sadiq Jatu on 23/07/26.
//

import UIKit

enum StudentMetricType {
    case absences, avgGrade, gradeLevel
}

class StudentMetricCell: UICollectionViewCell {
    
    static let reuseID   = "StudentMetricCell"
    let containerView    = UIView()
    let metricValue      = SMTitleLabel(textAlignment: .center, fontSize: 26)
    let metricValueLabel = SMTertitaryTitleLabel(textAlignment: .center, fontSize: 14)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContainerView()
        configureContent()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureContainerView() {
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    
    private func configureContent() {
        containerView.addSubviews(metricValue, metricValueLabel)
        
        NSLayoutConstraint.activate([
            metricValue.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            metricValue.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -10),
            metricValue.heightAnchor.constraint(equalToConstant: 28),
            
            metricValueLabel.topAnchor.constraint(equalTo: metricValue.bottomAnchor, constant: 5),
            metricValueLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            metricValueLabel.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    
    func set(type: StudentMetricType, value: String) {
        
        switch type {
            
        case .absences:
            metricValue.textColor = .label
            metricValueLabel.text = "Absences"
        case .avgGrade:
            metricValue.textColor = Colors.green
            metricValueLabel.text = "Avg Grade"
        case .gradeLevel:
            metricValue.textColor = Colors.blue
            metricValueLabel.text = "Grade"
        }
        
        metricValue.text          = value
    }
}
