//
//  AddStudentVC.swift
//  Student-Management-App
//
//  Created by Sadiq Jatu on 12/07/26.
//

import UIKit

protocol AddStudentVCDelegate: AnyObject {
    
    func didTapSaveButton()
}

class AddStudentVC: UIViewController {
    
    let containerView        = UIView()
    let stackView            = UIStackView()
    var firstNameLabel    : SMSecondaryTitleLabel!
    var lastNameLabel     : SMSecondaryTitleLabel!
    var firstNameTextfield: SMTextField!
    var lastNameTextField:  SMTextField!
    let saveButton           = SMButton(title: "Save Student Records", backgroundColor: Colors.blue, titleColor: .white)
    
    var selectedGrade: Int16 = 9        //Default selected grade
    let gradeOptions         = ["9", "10", "11", "12"]
    let gradeButton: UIButton = {
        let button  = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.setTitleColor(Colors.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    weak var delegate: AddStudentVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureContainerView()
        setupGradeMenu()
        configureStackView()
        configureSaveButton()
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Add Student"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.tintColor = Colors.blue
        cancelButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cancelButton)
    }
    
    
    func configureContainerView() {
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.layer.cornerRadius  = 18
        containerView.layer.borderColor   = UIColor.systemGray4.cgColor
        containerView.layer.borderWidth   = 1
        containerView.layer.masksToBounds = true
        
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            containerView.heightAnchor.constraint(equalToConstant: 160)
        ])
    }
    
    
    func configureStackView() {
        containerView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis          = .vertical
        stackView.distribution  = .fill
        
        let firstNameResult     = createFormRow(labelText: "First Name", placeholder: "Enter first name")
        let firstNameRow        = firstNameResult.rowStack
        self.firstNameTextfield = firstNameResult.textField
        self.firstNameLabel     = firstNameResult.label
        firstNameTextfield.delegate = self
        
        
        let lastNameResult     = createFormRow(labelText: "Last Name", placeholder: "Enter last name")
        let lastNameRow        = lastNameResult.rowStack
        self.lastNameTextField = lastNameResult.textField
        self.lastNameLabel     = lastNameResult.label
        lastNameTextField.delegate  = self
        
        
        let gradeRow           = createGradeRow()
        
        stackView.addArrangedSubview(firstNameRow)
        stackView.addArrangedSubview(createSeparator())
        stackView.addArrangedSubview(lastNameRow)
        stackView.addArrangedSubview(createSeparator())
        stackView.addArrangedSubview(gradeRow)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
    }
    
    
    func configureSaveButton() {
        view.addSubview(saveButton)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    
    func setupGradeMenu() {
        //Create an array of actions
        let menuActions = gradeOptions.map { optionString in
            return UIAction(title: optionString) { [weak self] action in
                guard let self = self else { return }
                self.gradeButton.setTitle("\(action.title)th Grade ⌵", for: .normal)
                
                if let gradeInt = Int16(action.title) {
                    self.selectedGrade = gradeInt
                }
            }
        }
        
        let menu = UIMenu(title: "Select Grade", children: menuActions)
        gradeButton.menu = menu
        gradeButton.showsMenuAsPrimaryAction = true
        
        gradeButton.setTitle("\(selectedGrade)th Grade ⌵", for: .normal)
    }
    
    
    func createFormRow(labelText: String, placeholder: String) -> (rowStack: UIStackView, textField: SMTextField, label: SMSecondaryTitleLabel) {
        let label     = SMSecondaryTitleLabel(text: labelText, textAlignment: .left, fontSize: 17)
        
        let textField = SMTextField(placeholder: placeholder, fontSize: 17, textAlignment: .left)
        
        let spacer    = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let stackView  = UIStackView(arrangedSubviews: [label, spacer, textField])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing      = 40
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        textField.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        
        return (stackView, textField, label)
    }
    
    
    func createGradeRow() -> UIStackView {
        let gradeLabel = SMSecondaryTitleLabel(text: "Grade Level", textAlignment: .left, fontSize: 17)
        
        let spacer    = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        let rowStack          = UIStackView(arrangedSubviews: [gradeLabel, spacer, gradeButton])
        rowStack.axis         = .horizontal
        rowStack.distribution = .fill
        rowStack.alignment    = .center
        rowStack.translatesAutoresizingMaskIntoConstraints = false
        
        rowStack.heightAnchor.constraint(equalToConstant: 50).isActive = true
        gradeButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        
        return rowStack
    }
    
    
    func createSeparator() -> UIView {
        let line = UIView()
        line.backgroundColor = .systemGray4
        line.translatesAutoresizingMaskIntoConstraints = false
        
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        return line
    }
    
    
    @objc func saveButtonPressed() {
        guard let firstName = firstNameTextfield.text, !firstName.isEmpty,
              let lastName  = lastNameTextField.text, !lastName.isEmpty else {
            
            UIView.animate(withDuration: 0.2) {
                
                if self.firstNameTextfield.text?.isEmpty ?? true {
                    self.firstNameLabel.textColor = .systemRed
                    self.firstNameTextfield.attributedPlaceholder = NSAttributedString(
                        string: "Enter first name",
                        attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemRed.withAlphaComponent(0.7)])
                }
                
                if self.lastNameTextField.text?.isEmpty ?? true {
                    self.lastNameLabel.textColor  = .systemRed
                    self.lastNameTextField.attributedPlaceholder = NSAttributedString(
                        string: "Enter last name",
                        attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemRed.withAlphaComponent(0.7)])
                }
            }
            return
        }
        
        CoreDataManager.shared.createStudent(
            firstName: firstNameTextfield.text!,
            lastName: lastNameTextField.text!,
            gradeLevel: selectedGrade
        )
        
        delegate.didTapSaveButton()
        dismissVC()
    }
    
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}


extension AddStudentVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.firstNameTextfield {
            UIView.animate(withDuration: 0.2) {
                self.firstNameLabel.textColor = .label
                
                self.firstNameTextfield.attributedPlaceholder = NSAttributedString(string: "Enter first name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.placeholderText])
            }
        }
        
        if textField == self.lastNameTextField {
            UIView.animate(withDuration: 0.2) {
                self.lastNameLabel.textColor = .label
                
                self.lastNameTextField.attributedPlaceholder = NSAttributedString(string: "Enter last name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.placeholderText])
            }
        }
    }
}
