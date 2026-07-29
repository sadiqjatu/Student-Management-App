//
//  StudentAttendanceCell.swift
//  Student-Management-App
//
//  Created by Sadiq Jatu on 28/07/26.
//

import UIKit

class StudentAttendanceCell: UITableViewCell {
    
    static let reuseID     = "StudentAttendanceCell"
    let containerView      = UIView()
    let innerContainerView = UIView()
    let studentNameLabel   = SMTitleLabel(textAlignment: .left, fontSize: 20)
    let statusLabel        = SMTertitaryTitleLabel(textAlignment: .left, fontSize: 14)
    let segmentedControl   = UISegmentedControl(items: ["P", "A", "T"])
    
    
    var onSegmentChanged: ((Int) -> Void)?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureContainerView()
        configureInnerContainerView()
        configureContentView()
        configureSegmentedControl()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureContainerView() {
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.backgroundColor = .systemBackground
        contentView.backgroundColor   = .clear
        backgroundColor               = .clear
        selectionStyle                = .none
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    
    private func configureInnerContainerView() {
        contentView.addSubview(innerContainerView)
        innerContainerView.translatesAutoresizingMaskIntoConstraints = false
        innerContainerView.backgroundColor = .clear
        innerContainerView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        NSLayoutConstraint.activate([
            innerContainerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            innerContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            innerContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            innerContainerView.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    
    private func configureContentView() {
        innerContainerView.addSubviews(studentNameLabel, statusLabel)
        
        NSLayoutConstraint.activate([
            studentNameLabel.topAnchor.constraint(equalTo: innerContainerView.topAnchor, constant: 10),
            studentNameLabel.leadingAnchor.constraint(equalTo: innerContainerView.leadingAnchor, constant: 16),
            studentNameLabel.trailingAnchor.constraint(equalTo: innerContainerView.trailingAnchor, constant: -5),
            studentNameLabel.heightAnchor.constraint(equalToConstant: 22),
            
            statusLabel.topAnchor.constraint(equalTo: studentNameLabel.bottomAnchor, constant: 5),
            statusLabel.leadingAnchor.constraint(equalTo: studentNameLabel.leadingAnchor),
            statusLabel.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    
    private func configureSegmentedControl() {
        containerView.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor      = .systemGray4
        
        updateSegmentColor(for: segmentedControl.selectedSegmentIndex)
        
        let normalText   = [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        segmentedControl.setTitleTextAttributes(normalText, for: .normal)
        
        let selectedText = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentedControl.setTitleTextAttributes(selectedText, for: .selected)
        
        segmentedControl.addTarget(self, action: #selector(handleSegmentChange(_:)), for: .valueChanged)
        segmentedControl.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        
        NSLayoutConstraint.activate([
            segmentedControl.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            segmentedControl.leadingAnchor.constraint(equalTo: innerContainerView.trailingAnchor, constant: 16),
            segmentedControl.heightAnchor.constraint(equalToConstant: 35)
        ])
        
    }
    
    
    func updateSegmentColor(for index: Int) {
        switch segmentedControl.selectedSegmentIndex {
            
        case 0:
            segmentedControl.selectedSegmentTintColor = Colors.green
        case 1:
            segmentedControl.selectedSegmentTintColor = Colors.red
        default:
            segmentedControl.selectedSegmentTintColor = Colors.yellow
        }
    }
    
    
    @objc func handleSegmentChange(_ sender: UISegmentedControl) {
        onSegmentChanged?(sender.selectedSegmentIndex)
        updateSegmentColor(for: sender.selectedSegmentIndex)
    }
}
