//
//  MetricCell.swift
//  Student-Management-App
//
//  Created by Sadiq Jatu on 06/07/26.
//

import UIKit

enum MetricType {
    case present, absent, tardy
}

class MetricCell: UICollectionViewCell {
    
    static let reuseID   = "MetricCell"
    let containerView    = UIView()
    let metricValue      = SMTitleLabel(textAlignment: .left, fontSize: 28)
    let metricValueLabel = SMTertitaryTitleLabel(textAlignment: .left, fontSize: 16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureContent()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor     = .systemBackground
        
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
            metricValue.heightAnchor.constraint(equalToConstant: 30),
            
            metricValueLabel.topAnchor.constraint(equalTo: metricValue.bottomAnchor, constant: 5),
            metricValueLabel.centerXAnchor.constraint(equalTo: metricValue.centerXAnchor),
            metricValueLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    
    func set(type: MetricType, value: String) {
        
        switch type {
            
        case .present:
            metricValue.textColor = Colors.green
            metricValueLabel.text = "Present"
        case .absent:
            metricValue.textColor = Colors.red
            metricValueLabel.text = "Absent"
        case .tardy:
            metricValue.textColor = Colors.yellow
            metricValueLabel.text = "Tardy"
        }
        
        metricValue.text          = value
    }
}
