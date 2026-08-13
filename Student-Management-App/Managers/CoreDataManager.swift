//
//  CoreDataManager.swift
//  Student-Management-App
//
//  Created by Sadiq Jatu on 01/07/26.
//

import UIKit
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    let context       = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let currentYear   = Calendar.current.component(.year, from: Date())
    
    
    func createStudent(firstName: String, lastName: String, gradeLevel: Int16) {    // Save Student to the database
        
        // Store id which consists -> current Year + 3 random characters
        let studentID = String(currentYear) + "-" + UUID().uuidString.prefix(3)
        
        let student        = Student(context: context)
        student.id         = studentID
        student.firstName  = firstName
        student.lastName   = lastName
        student.gradeLevel = gradeLevel
        student.currentGradePercentage = 0.0
        student.absencesCount = 0
        
        do {
            try context.save()
        } catch {
            print("Error saving student to the database! \(error.localizedDescription)")
        }
    }
    
    
    func fetchAllStudents() -> [Student] {           // Fetch all the students from the database
        let request: NSFetchRequest<Student> = Student.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "firstName", ascending: true),
            NSSortDescriptor(key: "lastName", ascending: true)
        ]
        
        do {
            let students = try context.fetch(request)
            return students
        } catch {
            print("Error fetching students from the database! \(error.localizedDescription)")
            return []
        }
    }
    
    
    func fetchRecords(for student: Student) -> [AttendanceRecord] {
        let recordRequest: NSFetchRequest<AttendanceRecord> = AttendanceRecord.fetchRequest()
        recordRequest.predicate = NSPredicate(format: "parentStudent == %@", student)
        recordRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            let records = try context.fetch(recordRequest)
            return records
        } catch {
            print("Error fetching atttendance record for this specific student: \(error.localizedDescription)")
            return []
        }
    }
    
    
    func fetchAttendanceRecordsForCurrentDate(for dateString: String) -> [AttendanceRecord] {
        let recordRequest: NSFetchRequest<AttendanceRecord>   = AttendanceRecord.fetchRequest()
        recordRequest.predicate = NSPredicate(format: "date == %@", dateString)
        
        do {
            let records = try context.fetch(recordRequest)
            return records
        } catch {
            print("Error fetching attendance records for this date: \(error.localizedDescription)")
            return []
        }
    }
    

    func createAssignment(assignmentName: String, dueDate: String, weight: Int16, maxScore: Int16, avgScore: Int16) {
        let assignment       = Assignment(context: context)
        assignment.title     = assignmentName
        assignment.dueDate   = dueDate
        assignment.weight    = weight
        assignment.maxPoints = maxScore
        assignment.avgScore  = Float(avgScore)
        
        do {
            try context.save()
        } catch {
            print("Error saving assignment to the database! \(error.localizedDescription)")
        }
    }
    
    
    func fetchAllAssignments() -> [Assignment] {
        let request: NSFetchRequest<Assignment> = Assignment.fetchRequest()
        request.sortDescriptors                 = [NSSortDescriptor(key: "title", ascending: true)]
        
        do {
            let assignments = try context.fetch(request)
            return assignments
        } catch {
            print("Error fetching assignments from the database! \(error.localizedDescription)")
            return []
        }
    }
    
    
    func fetchAllGrades(for student: Student) -> [Grade] {
        let request: NSFetchRequest<Grade>  = Grade.fetchRequest()
        request.predicate                   = NSPredicate(format: "parentStudent == %@", student)
        request.sortDescriptors             = [NSSortDescriptor(key: "parentAssignment.title", ascending: true)]
        
        do {
            let grades = try context.fetch(request)
            return grades
        } catch {
            print("Error fetching grades from the database! \(error.localizedDescription)")
            return []
        }
    }
    
    
    func fetchAllGrades(forAssignment assignment: Assignment) -> [Grade] {
        let request: NSFetchRequest<Grade> = Grade.fetchRequest()
        request.predicate = NSPredicate(format: "parentAssignment == %@", assignment)
        
        do {
            let grades = try context.fetch(request)
            return grades
        } catch {
            print("Error fetching records of \(assignment.title ?? "") assignment: \(error.localizedDescription)")
            return []
        }
    }
    
    
    func fetchStudentCount() -> Int {
        let request: NSFetchRequest<Student> = Student.fetchRequest()
        
        do {
            let count = try context.count(for: request)
            return count
        } catch {
            print("Error fetching all students count: \(error.localizedDescription)")
            return 0
        }
    }
    
    
    func fetchAttendanceCount(for dateString: String, status: String) -> Int {
        let request: NSFetchRequest<AttendanceRecord> = AttendanceRecord.fetchRequest()
        request.predicate = NSPredicate(format: "date == %@ AND status == %@", dateString, status)
        
        do {
            let count = try context.count(for: request)
            return count
        } catch {
            print("Error fetching count of attendance record \(status) status with \(dateString): \(error.localizedDescription)")
            return 0
        }
    }
    
    
    func fetchStudentAbsscenesCount(forStudent student: Student) -> Int {
        let request: NSFetchRequest<AttendanceRecord> = AttendanceRecord.fetchRequest()
        request.predicate = NSPredicate(format: "status == %@ AND parentStudent == %@", "A", student)
        
        do {
            let count = try context.count(for: request)
            return count
        } catch {
            print("Error fetching abscenes count: \(error.localizedDescription)")
            return 0
        }
    }
    
    
    func fetchStudentAttentionData(month: String) -> [AttentionRecord] {
        let request: NSFetchRequest<Student> = Student.fetchRequest()
        
        let mostAbsencesPredicate: NSPredicate = NSPredicate(
            format: "SUBQUERY(attendanceRecords, $record, $record.status == %@ AND $record.date BEGINSWITH %@).@count >= 4",
            "A",
            month
        )
        
        let lowPercentPredicate: NSPredicate   = NSPredicate(
            format: "currentGradePercentage <= 60 AND grades.@count > 0"
        )
        
        request.predicate = NSCompoundPredicate(
            type: .or,
            subpredicates: [mostAbsencesPredicate, lowPercentPredicate]
        )
        
        let nameSort: NSSortDescriptor = NSSortDescriptor(key: "firstName", ascending: true)
        request.sortDescriptors = [nameSort]
        
        do {
            let students = try context.fetch(request)
            
            let attentionData = students.map({ studentObj in
                return AttentionRecord(
                    studentName: "\(studentObj.firstName ?? "") \(studentObj.lastName ?? "")",
                    value: studentObj.currentGradePercentage <= 60 ? "D" : "\(studentObj.absencesCount)",
                    issueType: studentObj.currentGradePercentage <= 60 ? .grade : .attendance
                )
            })
            
            return attentionData
        } catch {
            print("Error fetching student attention data: \(error.localizedDescription)")
            return []
        }
    }
}
