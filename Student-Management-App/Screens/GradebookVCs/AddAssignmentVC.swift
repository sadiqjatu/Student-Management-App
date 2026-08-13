//
//  AddAssignmentVC.swift
//  Student-Management-App
//
//  Created by Sadiq Jatu on 01/08/26.
//

import UIKit

protocol AddAssignmentVCDelegate: AnyObject {
    
    func didTapSaveButton()
}

class AddAssignmentVC: UIViewController {
    
    let containerView       = UIView()
    let stackView           = UIStackView()
    let saveButton          = SMButton(title: "Save Assignment", backgroundColor: Colors.blue, titleColor: UIColor.white)
    
    var assignmentNameLabel: SMSecondaryTitleLabel!
    var dueDateLabel       : SMSecondaryTitleLabel!
    var weightLabel        : SMSecondaryTitleLabel!
    var maxScoreLabel      : SMSecondaryTitleLabel!
    
    var assignmentTextField: SMTextField!
    var dueDateTextField   : SMTextField!
    var weightTextField    : SMTextField!
    var maxScoreTextField  : SMTextField!
    
    weak var delegate: AddAssignmentVCDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        createDismissKeyboardGesture()
        configureContainerView()
        configureStackView()
        configureSaveButton()
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title                = "New Assignment"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let cancelButton     = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.tintColor = Colors.blue
        cancelButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cancelButton)
    }
    
    
    func createDismissKeyboardGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    
    func createFormRow(labelText: String, placeholder: String, keyboardType: UIKeyboardType) -> (rowStack: UIStackView, label: SMSecondaryTitleLabel, textField: SMTextField) {
        let label     = SMSecondaryTitleLabel(text: labelText, textAlignment: .left, fontSize: 18)
        let textField = SMTextField(placeholder: placeholder, fontSize: 18, textAlignment: .left)
        
        //1. Label strongly resists stretching and resists squishing
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        //2. Text field has a low hugging priority
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.keyboardType = keyboardType
        
        let stackView          = UIStackView(arrangedSubviews: [label, textField])
        stackView.axis         = .horizontal
        stackView.alignment    = .center
        stackView.distribution = .fill
        stackView.spacing      = 16         //A standard gap between the label and text field
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return (stackView, label, textField)
    }
    
    
    func createSeparator() -> UIView {
        let line    = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .systemGray4
        
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return line
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
            containerView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    
    func configureStackView() {
        containerView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis               = .vertical
        stackView.distribution       = .fill
            
        let assignmentNameResult     = createFormRow(labelText: "Name", placeholder: "e.g Pop Quiz 1", keyboardType: .default)
        let assignmentNameRow        = assignmentNameResult.rowStack
        self.assignmentTextField     = assignmentNameResult.textField
        self.assignmentNameLabel     = assignmentNameResult.label
        self.assignmentTextField.returnKeyType = .next
            
        let dueDateResult            = createFormRow(labelText: "Due Date", placeholder: "e.g July 5", keyboardType: .default)
        let dueDateRow               = dueDateResult.rowStack
        self.dueDateTextField        = dueDateResult.textField
        self.dueDateLabel            = dueDateResult.label
        self.dueDateTextField.returnKeyType = .next
            
        let weightResult             = createFormRow(labelText: "Weight %", placeholder: "10", keyboardType: .numberPad)
        let weightRow                = weightResult.rowStack
        self.weightTextField         = weightResult.textField
        self.weightLabel             = weightResult.label
        self.weightTextField.returnKeyType  = .next
            
        let maxScoreResult           = createFormRow(labelText: "Max Score", placeholder: "100", keyboardType: .numberPad)
        let maxScoreRow              = maxScoreResult.rowStack
        self.maxScoreTextField       = maxScoreResult.textField
        self.maxScoreLabel           = maxScoreResult.label
        self.maxScoreTextField.returnKeyType = .done
        
        assignmentTextField.delegate = self
        dueDateTextField.delegate    = self
        weightTextField.delegate     = self
        maxScoreTextField.delegate   = self
        
        stackView.addArrangedSubview(assignmentNameRow)
        stackView.addArrangedSubview(createSeparator())
        stackView.addArrangedSubview(dueDateRow)
        stackView.addArrangedSubview(createSeparator())
        stackView.addArrangedSubview(weightRow)
        stackView.addArrangedSubview(createSeparator())
        stackView.addArrangedSubview(maxScoreRow)
        
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
            saveButton.heightAnchor.constraint(equalToConstant: 60),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    
    @objc func saveButtonPressed() {
        print("Save assignment button pressed")
        var isValid = true
        
        UIView.animate(withDuration: 0.2) {
            
            if self.assignmentTextField.text?.isEmpty ?? true {
                self.showError(for: self.assignmentNameLabel, textField: self.assignmentTextField, placeholder: "e.g Enter name")
                isValid = false
            }
            
            if self.dueDateTextField.text?.isEmpty ?? true {
                self.showError(for: self.dueDateLabel, textField: self.dueDateTextField, placeholder: "Enter due date")
                isValid = false
            }
            
            if let weightText  = self.weightTextField.text, let weight = Int(weightText), weight >= 0, weight <= 100 {
                //Valid weight
            } else {
                self.weightTextField.text?.removeAll()
                self.showError(for: self.weightLabel, textField: self.weightTextField, placeholder: "Enter number (0 - 100)")
                isValid = false
            }
            
            
            if let scoreText = self.maxScoreTextField.text, let maxScore = Int(scoreText), maxScore >= 0 {
                //valid max score
            } else {
                self.maxScoreTextField.text?.removeAll()
                self.showError(for: self.maxScoreLabel, textField: self.maxScoreTextField, placeholder: "Enter valid number")
                isValid = false
            }
        }
        
        
        //If any validation failed, return from here
        guard isValid else { return }
        
        //If we reach at this point then the data is 100% valid and safe to use
        let assignmentName = assignmentTextField.text!
        let dueDate        = dueDateTextField.text!
        let weight         = Int16(weightTextField.text!)!
        let maxScore       = Int16(maxScoreTextField.text!)!
        
        print("Success saving: \(assignmentName) \(dueDate) \(weight) \(maxScore)")
        CoreDataManager.shared.createAssignment(
            assignmentName: assignmentName,
            dueDate: dueDate,
            weight: weight,
            maxScore: maxScore,
            avgScore: 0         //Always starts with zero
        )
        
        delegate.didTapSaveButton()
        dismissVC()
    }
    
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    //MARK: - Helper method
    private func showError(for label: UILabel, textField: UITextField, placeholder: String) {
        label.textColor = .systemRed
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemRed.withAlphaComponent(0.7)]
        )
    }
}


extension AddAssignmentVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case assignmentTextField:
            animateFocus(for: assignmentNameLabel, textField: textField, placeholder: "e.g Pop Quiz 1")
        case dueDateTextField:
            animateFocus(for: dueDateLabel, textField: textField, placeholder: "e.g July 5")
        case weightTextField:
            animateFocus(for: weightLabel, textField: textField, placeholder: "10")
        case maxScoreTextField:
            animateFocus(for: maxScoreLabel, textField: textField, placeholder: "100")
        default:
            break
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case assignmentTextField:
            dueDateTextField.becomeFirstResponder()
        case dueDateTextField:
            weightTextField.becomeFirstResponder()
        default:
            break
        }
        
        return true
    }
    
    
    //MARK: - Helper Method
    private func animateFocus(for label: UILabel, textField: UITextField, placeholder: String) {
        UIView.animate(withDuration: 0.2) {
            label.textColor = .label
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [NSAttributedString.Key.foregroundColor : UIColor.placeholderText]
            )
        }
    }
}
