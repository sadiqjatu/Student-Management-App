//
//  AttendanceVC.swift
//  Student-Management-App
//
//  Created by Sadiq Jatu on 04/07/26.
//

import UIKit
import CoreData

class AttendanceVC: UIViewController {
    
    //Declare the calendar view
    let calendarView           = UICalendarView()
    let tableView              = UITableView()
    var students: [Student]    = []
    var attendanceMap: [Student: AttendanceRecord] = [:]      //Dictionary for 0(1) lookup
    
    let context                = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedDate           = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureCalendarView()
        configureTableView()
    }
    
    
    func loadData(for dateString: String) {
        //1. Fetch all the students
        self.students    = CoreDataManager.shared.fetchAllStudents()
        
        //2. Fetch attendance records for this EXACT date
        print(dateString)
        let todayRecords = CoreDataManager.shared.fetchAttendanceRecordsForCurrentDate(for: dateString)
        
        //3. Build the dictionary (Lookup Map)
        attendanceMap.removeAll()
        for record in todayRecords {
            if let student = record.parentStudent {
                attendanceMap[student] = record
            }
        }
        print("Student array count: \(self.students.count)")      //For debugging purpose
        print("Attendance map dictionary count: \(self.attendanceMap.count)") //For debugging purpose
        
        tableView.reloadData()
    }
    
    
    func updateAttendanceRecord(for student: Student, newStatus: String, currentDate: String) {
        //1. Record already exists
        if let record = attendanceMap[student] {
            //UPDATE existing record
            record.status = newStatus
        } else {
            //CREATE new record
            let newRecord           = AttendanceRecord(context: context)
            newRecord.date          = currentDate
            newRecord.status        = newStatus
            newRecord.parentStudent = student   //Link relationship
            
            // Add to attendanceMap so the database and current dicionary both are aligned
            attendanceMap[student]  = newRecord
        }
        
        do {
            try context.save()
            student.absencesCount = Int16(CoreDataManager.shared.fetchStudentAbsscenesCount(forStudent: student))
        } catch {
            print("Error saving or updating attendance records \(error.localizedDescription)")
        }
    }
    
    
    func indexForStatus(_ status: String) -> Int {
        if status == "P" {
            return 0
        } else if status == "A" {
            return 1
        } else {
            return 2
        }
    }
    
    
    func statusForIndex(_ index: Int) -> String {
        if index == 0 {
            return "P"
        } else if index == 1 {
            return "A"
        } else {
            return "T"
        }
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemGray5
    }
    
    
    func configureCalendarView() {
        view.addSubview(calendarView)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        //Configuration: Set the calendar type and font design
        calendarView.calendar        = Calendar.current
        calendarView.locale          = .current
        calendarView.fontDesign      = .rounded
        calendarView.backgroundColor = .systemBackground
        calendarView.timeZone        = TimeZone.current
        
        //Define available date range
        let pastDate = Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date()
        let currentDate = Date()
        let localOffset = TimeInterval(TimeZone.current.secondsFromGMT(for: currentDate))
        let localDeviceDate = currentDate.addingTimeInterval(localOffset)
        
        calendarView.availableDateRange = DateInterval(start: pastDate, end: localDeviceDate)
        print(localDeviceDate)
        
        //Delegates & selection
        //Set up single-date selection behaviour
        let selection                  = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = selection
        
        //Setup constraints
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.backgroundColor              = .clear
        tableView.dataSource                   = self
        tableView.delegate                     = self
        tableView.rowHeight                    = 64
        tableView.layer.cornerRadius           = 18
        tableView.showsVerticalScrollIndicator = false
        tableView.register(StudentAttendanceCell.self, forCellReuseIdentifier: StudentAttendanceCell.reuseID)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
}


extension AttendanceVC: UICalendarSelectionSingleDateDelegate {
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let dateComponents = dateComponents, let date = dateComponents.date else { return }
        
        loadData(for: date.convertToYearMonthDay())
        self.selectedDate = date.convertToYearMonthDay()
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
        return true
    }
}


extension AttendanceVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StudentAttendanceCell.reuseID, for: indexPath) as! StudentAttendanceCell
        let student         = students[indexPath.row]
        let studentFullName = "\(student.firstName ?? "N/A") \(student.lastName ?? "")"
        
        cell.studentNameLabel.text = studentFullName
        
        //Check our instant lookup dictionary
        if let record = attendanceMap[student] {
            //Record exists for today
            cell.segmentedControl.selectedSegmentIndex = indexForStatus(record.status ?? "P")
            cell.updateSegmentColor(for: indexForStatus(record.status ?? "P"))
            
            if record.status == "P" {
                cell.statusLabel.text = "Last status: Present"
            } else if record.status == "A" {
                cell.statusLabel.text = "Last status: Absent"
            } else {
                cell.statusLabel.text = "Last status: Tardy"
            }
            
        } else {
            //Brand new day - no record exists yet!
            cell.segmentedControl.selectedSegmentIndex = UISegmentedControl.noSegment
            cell.statusLabel.text     = "Last status: N/A"
        }
        
        cell.onSegmentChanged = { [weak self] index in
            guard let self = self else { return }
            
            self.updateAttendanceRecord(for: student, newStatus: statusForIndex(index), currentDate: selectedDate)
            
            if index == 0 {
                cell.statusLabel.text = "Last status: Present"
            } else if index == 1 {
                cell.statusLabel.text = "Last status: Absent"
            } else {
                cell.statusLabel.text = "Last status: Tardy"
            }
        }
        
        return cell
    }
}


extension AttendanceVC: UITableViewDelegate {
    
    //Round the corners of first and last of table view
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let totalStudents = tableView.numberOfRows(inSection: 0)
        
        guard let studentAttendanceCell = cell as? StudentAttendanceCell else { return }
        
        if indexPath.row == 0 {
            studentAttendanceCell.containerView.layer.cornerRadius  = 18
            studentAttendanceCell.containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if indexPath.row == totalStudents - 1{
            studentAttendanceCell.containerView.layer.cornerRadius  = 18
            studentAttendanceCell.containerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            studentAttendanceCell.containerView.layer.cornerRadius  = 0
            studentAttendanceCell.containerView.layer.maskedCorners = []
        }
        
        if totalStudents == 1 {
            studentAttendanceCell.containerView.layer.cornerRadius  = 18
            studentAttendanceCell.containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        
        studentAttendanceCell.clipsToBounds = true
    }
}
