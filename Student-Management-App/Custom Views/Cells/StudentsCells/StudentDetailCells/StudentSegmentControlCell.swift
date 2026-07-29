//
//  StudentSegmentControlCell.swift
//  Student-Management-App
//
//  Created by Sadiq Jatu on 24/07/26.
//

import UIKit

class StudentSegmentControlCell: UICollectionReusableView {
    
    static let reuseID   = "StudentSegmentControlCell"
    
    var onSegmentChanged: ((Int) -> Void)?
    
    lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Attendance Log", "Academic Grades"])
        
        //styling
        control.selectedSegmentIndex     = 0
        control.backgroundColor          = .systemGray4
        control.selectedSegmentTintColor = .systemBackground
        
        let normalText   = [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        control.setTitleTextAttributes(normalText, for: .normal)
        
        let selectedText = [NSAttributedString.Key.foregroundColor: UIColor.label]
        control.setTitleTextAttributes(selectedText, for: .selected)
        control.addTarget(self, action: #selector(handleSegmentChange(_:)), for: .valueChanged)
        
        return control
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            segmentedControl.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    
    @objc func handleSegmentChange(_ sender: UISegmentedControl) {
        onSegmentChanged?(sender.selectedSegmentIndex)
    }
}
