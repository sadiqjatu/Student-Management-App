//
//  GradeCell.swift
//  Student-Management-App
//
//  Created by Sadiq Jatu on 07/08/26.
//

import UIKit

class GradeCell: UITableViewCell {
    
    static let reuseID = "GradeCell"
    let containerView  = UIView()
    let studentName    = SMSecondaryTitleLabel(text: "", textAlignment: .left, fontSize: 22)
    let maxScoreLabel  = SMTertitaryTitleLabel(textAlignment: .right, fontSize: 20)
    let scoreTextField = SMTextField(placeholder: "0", fontSize: 20, textAlignment: .center)
    
    var onGradeEntered: ((Int?) -> Void)?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        configureContainerView()
        configureContent()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepareForReuse() {       //Cleanly wipe recycle cell states before reuse
        super.prepareForReuse()
        scoreTextField.text = ""
        scoreTextField.textColor = .secondaryLabel
        onGradeEntered = nil
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
        containerView.addSubviews(studentName, maxScoreLabel, scoreTextField)
        
        scoreTextField.keyboardType       = .numberPad
        scoreTextField.returnKeyType      = .done
        scoreTextField.layer.borderColor  = UIColor.systemGray4.cgColor
        scoreTextField.layer.borderWidth  = 1
        scoreTextField.layer.cornerRadius = 12
        scoreTextField.addTarget(self, action: #selector(textFieldDidChange(_ :)), for: .editingDidEnd)
        scoreTextField.addTarget(self, action: #selector(changeTextColor), for: .editingChanged)
        
        NSLayoutConstraint.activate([
            studentName.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            studentName.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            studentName.heightAnchor.constraint(equalToConstant: 24),
            
            maxScoreLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            maxScoreLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            maxScoreLabel.heightAnchor.constraint(equalToConstant: 22),
            
            scoreTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            scoreTextField.trailingAnchor.constraint(equalTo: maxScoreLabel.leadingAnchor, constant: -5),
            scoreTextField.leadingAnchor.constraint(greaterThanOrEqualTo: studentName.trailingAnchor, constant: 16),
            scoreTextField.widthAnchor.constraint(equalToConstant: 50),
            scoreTextField.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text ?? ""
        
        if text.isEmpty {
            onGradeEntered?(nil)
        } else if let newScore = Int(text) {
            //Trigger the closure, passing the data back
            onGradeEntered?(newScore)
        }
    }
    
    
    @objc func changeTextColor() {
        scoreTextField.textColor = .secondaryLabel
    }
}
