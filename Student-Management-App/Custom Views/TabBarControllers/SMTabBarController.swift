//
//  SMTabBarController.swift
//  Student-Management-App
//
//  Created by Sadiq Jatu on 04/07/26.
//

import UIKit

class SMTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().tintColor = Colors.blue
        viewControllers                 = [createDashboardNC(), createStudentsNC(), createAttendanceNC(), createGradebookNC()]
    }
    
    
    func createDashboardNC() -> UINavigationController {
        let dashboardVC   = DashboardVC()
        dashboardVC.title = "Overview"
        
        let nav           = UINavigationController(rootViewController: dashboardVC)
        nav.tabBarItem    = UITabBarItem(title: "Overview", image: Icons.dashboard, tag: 0)
        
        return nav
    }
    
    
    func createStudentsNC() -> UINavigationController {
        let studentsVC     = StudentsVC()
        studentsVC.title   = "Students"
        
        let nav           = UINavigationController(rootViewController: studentsVC)
        nav.tabBarItem    = UITabBarItem(title: "Students", image: Icons.twoPerson, tag: 1)
        
        return nav
    }
    
    
    func createAttendanceNC() -> UINavigationController {
        let attendanceVC   = AttendanceVC()
        attendanceVC.title = "Attendance"
        
        let nav            = UINavigationController(rootViewController: attendanceVC)
        nav.tabBarItem     = UITabBarItem(title: "Attendance", image: Icons.calendar, tag: 2)
        
        return nav
    }
    
    
    func createGradebookNC() -> UINavigationController {
        let gradebookVC    = GradebookVC()
        gradebookVC.title  = "Gradebook"
        
        let nav            = UINavigationController(rootViewController: gradebookVC)
        nav.tabBarItem     = UITabBarItem(title: "Gradebook", image: Icons.book, tag: 3)
        
        return nav
    }
}
