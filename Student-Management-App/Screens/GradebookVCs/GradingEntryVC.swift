//
//  GradingEntryVC.swift
//  Student-Management-App
//
//  Created by Sadiq Jatu on 06/08/26.
//

import UIKit
import CoreData

class GradingEntryVC: UIViewController {
    
    var selectedAssignment: Assignment!
    let detailView          = UIView()
    var avgScoreLabel:      SMTertitaryTitleLabel!
    let tableView           = UITableView()
    var students: [Student] = []
    let saveButton          = SMButton(title: "Save Grades", backgroundColor: Colors.blue, titleColor: .white)
    
    let context             = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var gradeMap: [Student : Grade] = [:]
    
    var avgScore: Float     = 0
    
    
    init(selectedAssignment: Assignment){
        super.init(nibName: nil, bundle: nil)
        self.selectedAssignment = selectedAssignment
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubviews(detailView, tableView, saveButton)
        configureViewController()
        setupDetailView()
        configureTableView()
        configureSaveButton()
        addNotificationObservers()
        setupHideKeyboardOnTap()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        calculateAverageScore()
        
        if context.hasChanges{
            saveContext()
        }
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemGray5
        title = selectedAssignment.title
    }
    
    
    func loadData() {
        print("loadData()")
        //1. Fetch all the students
        students             = CoreDataManager.shared.fetchAllStudents()
        
        //2. Fetch all the grades for the selected assignment
        let assignmentGrades = CoreDataManager.shared.fetchAllGrades(forAssignment: selectedAssignment)
        
        //3. Build the dictionary (Lookup map)
        gradeMap.removeAll()
        for grade in assignmentGrades {
            if let student = grade.parentStudent {
                gradeMap[student] = grade
            }
        }
        
        print("Student array count: ", students.count)
        print("grade map count: ", gradeMap.count)
        
        tableView.reloadData()
    }
    
    
    func updateOrCreateGradeRecord(for student: Student, newScore: Int) {
        print("Update Grade record triggered!")
        
        //Grade record already exists
        if let grade = gradeMap[student] {
            //Update the grade
            grade.earnedPoints = Int16(newScore)
        } else {
            //CREATE new record
            let newGrade              = Grade(context: context)
            newGrade.earnedPoints     = Int16(newScore)
            
            //Link relationship
            newGrade.parentAssignment = selectedAssignment
            newGrade.parentStudent    = student
            
            //Add to gradeMap so the database and current dictionary both are aligned
            gradeMap[student]         = newGrade
        }
        
        recalculatePercentage(for: student)
        
        print("Student array count: ", students.count)
        print("grade map count: ", gradeMap.count)
    }
    
    
    func deleteGradeRecord(for student: Student) {
        print("Delete grade record triggered!")
        
        guard let grade = gradeMap[student] else { return }
        
        context.delete(grade)                   //Delete the object directly from the context (safe and cash free)
        gradeMap.removeValue(forKey: student)   //Also delete it from the grade map to keep everything in sync
    }
    
    
    func setupDetailView() {
        detailView.translatesAutoresizingMaskIntoConstraints = false
        
        let dueDateLabel = UIHelper.createTertiaryLabel(label: "Due \(selectedAssignment.dueDate ?? "N/A")", textAlignment: .left)
        let weightLabel  = UIHelper.createTertiaryLabel(label: "• Weight \(selectedAssignment.weight)%", textAlignment: .left)
        
        avgScoreLabel    = UIHelper.createTertiaryLabel(
            label: "\(selectedAssignment.avgScore.formatted(.number.precision(.fractionLength(2))))% Avg",
            textAlignment: .right
        )
        
        detailView.addSubviews(dueDateLabel, weightLabel, avgScoreLabel)
        
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailView.heightAnchor.constraint(equalToConstant: 30),
            
            dueDateLabel.centerYAnchor.constraint(equalTo: detailView.centerYAnchor),
            dueDateLabel.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 16),
            dueDateLabel.heightAnchor.constraint(equalToConstant: 18),
            
            weightLabel.centerYAnchor.constraint(equalTo: detailView.centerYAnchor),
            weightLabel.leadingAnchor.constraint(equalTo: dueDateLabel.trailingAnchor),
            weightLabel.heightAnchor.constraint(equalToConstant: 18),
            
            avgScoreLabel.centerYAnchor.constraint(equalTo: detailView.centerYAnchor),
            avgScoreLabel.trailingAnchor.constraint(equalTo: detailView.trailingAnchor, constant: -16),
            avgScoreLabel.leadingAnchor.constraint(greaterThanOrEqualTo: weightLabel.trailingAnchor, constant: 16),
            avgScoreLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    
    func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.dataSource                   = self
        tableView.rowHeight                    = 66
        tableView.backgroundColor              = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.keyboardDismissMode          = .onDrag
        tableView.register(GradeCell.self, forCellReuseIdentifier: GradeCell.reuseID)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: detailView.bottomAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: saveButton.topAnchor)
        ])
    }
    
    
    func configureSaveButton() {
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 60),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    
    func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    func setupHideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    
    func saveContext() {
        do {
            print("Save context() called")
            try context.save()
        } catch {
            print("Error saving or updating grade records: \(error.localizedDescription)")
        }
    }
    
    
    func calculateAverageScore() {
        var totalMarks: Float   = 0
        for grade in gradeMap {
            print((grade.value.earnedPoints * 100) / selectedAssignment.maxPoints)
            
            totalMarks = totalMarks + Float(grade.value.earnedPoints * 100) / Float(selectedAssignment.maxPoints)
        }
        print("Total marks: \(totalMarks)")
        if totalMarks > 0 {
            avgScore = totalMarks / Float(gradeMap.count)
        }
        print("Average score: \(avgScore)")
        selectedAssignment.avgScore = avgScore
    }
    
    
    func recalculatePercentage(for student: Student) {
        print("Recalculation triggered!")
        guard let gradeSet = student.grades as? Set<Grade>, !gradeSet.isEmpty else {
            student.currentGradePercentage = 0.0
            print("returned")
            return
        }
        
        var totalEarned: Float = 0.0
        var totalMax   : Float = 0.0
        
        for grade in gradeSet {
            totalEarned += Float(grade.earnedPoints)
            
            if let assignment = grade.parentAssignment {
                totalMax = totalMax + Float(assignment.maxPoints)
            }
        }
        print("Total earned points: \(totalEarned)")
        print("Total max points: \(totalMax)")
        
        if totalMax > 0 {
            student.currentGradePercentage = ((totalEarned * 100.0) / totalMax)
            print(student.currentGradePercentage)
        } else {
            student.currentGradePercentage = 0.0
        }
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        print("Keyboard will show")
        
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            
            //Add padding to bottom of the table view
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight - 150, right: 0)
        }
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        print("Keyboard will hide")
        
        tableView.contentInset = .zero
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    @objc func saveButtonPressed() {
        print("Save Grades button pressed!")
        
        //Calculate average
        calculateAverageScore()
        
        //Save the context
        saveContext()
        
        //pop the view controller
        navigationController?.popViewController(animated: true)
    }
}


extension GradingEntryVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell    = tableView.dequeueReusableCell(withIdentifier: GradeCell.reuseID, for: indexPath) as! GradeCell
        
        let student = students[indexPath.row]
        cell.studentName.text   = "\(student.firstName ?? "N/A") \(student.lastName ?? "")"
        cell.maxScoreLabel.text = "/ \(selectedAssignment.maxPoints)"
        
        //Check our instant lookup dictionary
        if let grade = gradeMap[student] {
            //Grade exist for a student
            cell.scoreTextField.text = String(grade.earnedPoints)
        } else {
            //Grade doesn't exist for a student
            cell.scoreTextField.text = ""
        }
        
        //Assign onGradeEntered closure
        cell.onGradeEntered = { [weak self] newScore in
            guard let self = self else { return }
            
            //Handle explicit deletion (when text field is cleared i.e returns nil)
            guard let score = newScore else {
                self.deleteGradeRecord(for: student)
                self.calculateAverageScore()
                self.avgScoreLabel.text = "\(avgScore.formatted(.number.precision(.fractionLength(2))))% Avg"
                self.saveContext()
                self.recalculatePercentage(for: student)
                return
            }
            
            //Validate valid entry scores
            guard score <= self.selectedAssignment.maxPoints && score >= 0 else {
                print("\(score) is invalid")
                cell.scoreTextField.textColor = .systemRed
                return
            }
            
            cell.scoreTextField.textColor     = .secondaryLabel
            self.updateOrCreateGradeRecord(for: student, newScore: score)
            
            self.calculateAverageScore()
            self.avgScoreLabel.text = "\(avgScore.formatted(.number.precision(.fractionLength(2))))% Avg"
        }
        
        return cell
    }
}
