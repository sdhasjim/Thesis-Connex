//
//  TaskViewModel.swift
//  Thesis-Connex
//
//  Created by Samuel Dennis on 21/12/22.
//

import Foundation

class TaskViewModel: ObservableObject {
    
    @Published var tasks = [Task]()
    @Published var assignedTasks = [Task]()
    @Published var todoTasks = [Task]()
    @Published var progressingTasks = [Task]()
    @Published var doneTasks = [Task]()
    @Published var task1 = 0
    
//    init() {
//        getData()
//    }
    
    func scoringProject(){
        task1 = tasks.count
        print(task1)
    }
    
    func updateExistingData(taskToUpdate: Task, name: String, assignee: String, desc: String, priority: String, dueDate: String) {
        
        let db = FirebaseManager.shared.firestore
        
        // Set the data to update
        db.collection("tasks").document(taskToUpdate.id).setData(
            ["name": name,
             "assignee": assignee,
             "desc": desc,
             "priority": priority,
             "dueDate": dueDate
            
            ]
            , merge: true) { error in
            
            if error == nil,
               let index = self.tasks.firstIndex(of: taskToUpdate){
                
                self.tasks[index].name = name
                self.tasks[index].assignee = assignee
                self.tasks[index].desc = desc
                self.tasks[index].priority = priority
                self.tasks[index].dueDate = dueDate
                
            }
        }
        
    }
    
    func updateExistingDataStatus(taskToUpdate: Task, status: String) {
        
        let db = FirebaseManager.shared.firestore
        
        // Set the data to update
        db.collection("tasks").document(taskToUpdate.id).setData(
            ["status": status
            
            ]
            , merge: true) { error in
            
//                if error == nil {
//                    self.getDataFromStatusAndProjectID(projectID: <#T##String#>, status: status)
//                }
            if error == nil,
               let index = self.tasks.firstIndex(of: taskToUpdate){

                self.tasks[index].status = status
            }
        }
        
    }
    
    
    func deleteData(taskToDelete: Task) {
        // Get a reference to the database
        let db = FirebaseManager.shared.firestore
        
        // Specify the document to delete
        db.collection("tasks").document(taskToDelete.id).delete { error in
            // Check for errors
            
            if error == nil {
                // No errors
                
                //Update the UI from the main thread
                DispatchQueue.main.async {
                    
                    // Remove the project that was just deleted
                    self.tasks.removeAll { task in
                        // Check for the project to remove
                        
                        return task.id == taskToDelete.id
                    }
                }
                
            }
        }
    }
    
    func getDataFromStatus(status: String) {
        let db = FirebaseManager.shared.firestore
        
        let taskRef = db.collection("tasks")
        
        let query = taskRef.whereField("status", isEqualTo: status)
        
        query.addSnapshotListener { querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                    DispatchQueue.main.async {
                        self.tasks = querySnapshot!.documents.map { d in
                            
                            return Task(id: d.documentID,
                                        name: d["name"] as? String ?? "",
                                        assignee: d["assignee"] as? String ?? "",
                                        desc: d["desc"] as? String ?? "",
                                        priority: d["priority"] as? String ?? "",
                                        dueDate: d["dueDate"] as? String ?? "",
                                        status: d["status"] as? String ?? ""
                            
                            )
                        }
                    }
            }
        }
    }
    
    func getDataFromStatusAndProjectID(projectID: String, status: String) {
        let db = FirebaseManager.shared.firestore
        
        let taskRef = db.collection("tasks")
        
        let query =
        taskRef
            .whereField("status", isEqualTo: status)
            .whereField("projectID", isEqualTo: projectID)
        
        query.addSnapshotListener { querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                    DispatchQueue.main.async {
                        if status == "todo" {
                            self.todoTasks = querySnapshot!.documents.map { d in

                                return Task(id: d.documentID,
                                            name: d["name"] as? String ?? "",
                                            assignee: d["assignee"] as? String ?? "",
                                            desc: d["desc"] as? String ?? "",
                                            priority: d["priority"] as? String ?? "",
                                            dueDate: d["dueDate"] as? String ?? "",
                                            status: d["status"] as? String ?? ""

                                )
                            }
                        }
                        else if status == "progressing" {
                            self.progressingTasks = querySnapshot!.documents.map { d in

                                return Task(id: d.documentID,
                                            name: d["name"] as? String ?? "",
                                            assignee: d["assignee"] as? String ?? "",
                                            desc: d["desc"] as? String ?? "",
                                            priority: d["priority"] as? String ?? "",
                                            dueDate: d["dueDate"] as? String ?? "",
                                            status: d["status"] as? String ?? ""

                                )
                            }
                        }
                        else {
                            self.doneTasks = querySnapshot!.documents.map { d in

                                return Task(id: d.documentID,
                                            name: d["name"] as? String ?? "",
                                            assignee: d["assignee"] as? String ?? "",
                                            desc: d["desc"] as? String ?? "",
                                            priority: d["priority"] as? String ?? "",
                                            dueDate: d["dueDate"] as? String ?? "",
                                            status: d["status"] as? String ?? ""

                                )
                            }
                        }

                    }
            }
        }
    }
    
    func getDataFromProjectID(projectID: String) {
        let db = FirebaseManager.shared.firestore
        
        let taskRef = db.collection("tasks")
        
        let query = taskRef.whereField("projectID", isEqualTo: projectID)
        
        query.addSnapshotListener { querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                    DispatchQueue.main.async {
                        self.tasks = querySnapshot!.documents.map { d in
                            
                            return Task(id: d.documentID,
                                        name: d["name"] as? String ?? "",
                                        assignee: d["assignee"] as? String ?? "",
                                        desc: d["desc"] as? String ?? "",
                                        priority: d["priority"] as? String ?? "",
                                        dueDate: d["dueDate"] as? String ?? "",
                                        status: d["status"] as? String ?? ""
                            
                            )
                        }
                    }
            }
        }
    }
    
    func getData() {
        guard let userEmail = FirebaseManager.shared.auth.currentUser?.email else { return }
        
        let db = FirebaseManager.shared.firestore
        
        let taskRef = db.collection("tasks")
        
        let query = taskRef.whereField("assignee", isEqualTo: userEmail)
        
        // Read the documents at a specific path
        query.addSnapshotListener { snapshot, error in
            
            // Check for errors
            if error == nil {
                // No error
                if let snapshot = snapshot {
                    
                    // Update the list property in the main thread
                    DispatchQueue.main.async {
                        // Get all the documents and create Projects
                        self.assignedTasks = snapshot.documents.map { d in
                            
                            // Create a project for each document iterated
                            return Task(id: d.documentID,
                                        name: d["name"] as? String ?? "",
                                        assignee: d["assignee"] as? String ?? "",
                                        desc: d["desc"] as? String ?? "",
                                        priority: d["priority"] as? String ?? "",
                                        dueDate: d["dueDate"] as? String ?? "",
                                        status: d["status"] as? String ?? ""
                            
                            )
                        }
                    }
                    

                }
            }
            else {
                // Handle the error
            }
        }
    }
    
    func addData(projectID: String, name: String) {
        
        let db = FirebaseManager.shared.firestore
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let taskData = ["uid": uid, "name": name, "projectID": projectID, "status": "todo", "assignee": ""]
        
        db.collection("tasks")
            .addDocument(data: taskData) { err in
                if let err = err {
                    print(err)
                    return
                }
                
                self.getDataFromProjectID(projectID: projectID)
                print("Success")
            }
    }
}
