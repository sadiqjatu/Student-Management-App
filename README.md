# Student-Management-App

A native iOS application designed to digitize and simplify daily educational tracking. 

**The Goal:** Teachers need a fast, reliable way to manage classroom data without relying on fragmented tools, paper records, or clunky web portals.  
**The Solution:** A comprehensive, completely offline iOS application that brings core educational tasks directly to the device.

## App demo
https://github.com/user-attachments/assets/2960ba1c-89b9-495c-87fc-3c9a0aace754

 By centralizing student profiles, daily attendance, and gradebooks into one seamless interface, this app drastically streamlines the educator's daily workflow.


## Core Features

* **Classroom Dashboard:** A high-level overview screen providing immediate access to core classroom metrics and quick actions.
* **Student Roster & Detail Screens:** A dedicated list view to manage the classroom roster, branching into detailed, individual student profile screens for granular tracking.
* **Daily Attendance Tracker:** A streamlined, custom interface allowing educators to quickly log daily statuses (Present, Absent, Tardy) for the entire class.
* **Gradebook Management:** A custom-built flow for creating assignments, inputting scores, and tracking overall academic progress.
* **Offline-First Reliability:** Full local data persistence utilizing Core Data, allowing users to safely manage classroom records without an internet connection.

## 🏗 Architecture & Tech Stack

This application was built entirely from scratch to demonstrate production-level iOS development practices, strictly adhering to the **Model-View-Controller (MVC)** design pattern.

* **Language:** Swift
* **UI Framework:** 100% Programmatic UIKit & Auto Layout (Zero Storyboards)
* **Architecture:** MVC (Model-View-Controller)
* **Local Storage:** Core Data
* **Data Management:** A dedicated `CoreDataManager` abstraction layer isolates all database queries, keeping View Controllers lightweight and solely focused on presentation and state management.


## 💻 Installation & Setup

To run this project locally on your machine:

1. Clone the repository: git clone  https://github.com/sadiqjatu/Student-Management-App.git
2. Open the StudentManagementApp.xcodeproj in Xcode
3. Select an iOS simulator and press cmd + R to run.
