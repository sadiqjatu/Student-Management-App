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
        
        do {
            try context.save()
        } catch {
            print("Error saving student to the database! \(error.localizedDescription)")
        }
    }
    
    
    func fetchAllStudents() -> [Student] {           // Fetch all the students from the database
        let request: NSFetchRequest<Student> = Student.fetchRequest()
        
        do {
            let students = try context.fetch(request)
            return students
        } catch {
            print("Error fetching students from the database! \(error.localizedDescription)")
            return []
        }
    }
}
