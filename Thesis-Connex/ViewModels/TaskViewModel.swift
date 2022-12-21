//
//  TaskViewModel.swift
//  Thesis-Connex
//
//  Created by Samuel Dennis on 21/12/22.
//

import Foundation

class TaskViewModel: ObservableObject {
    
    @Published var tasks = [Task]()
    
    init() {
        getData()
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
    
    func getData() {
        let db = FirebaseManager.shared.firestore
        
        // Read the documents at a specific path
        db.collection("tasks").getDocuments { snapshot, error in
            
            // Check for errors
            if error == nil {
                // No error
                if let snapshot = snapshot {
                    
                    // Update the list property in the main thread
                    DispatchQueue.main.async {
                        // Get all the documents and create Projects
                        self.tasks = snapshot.documents.map { d in
                            
                            // Create a project for each document iterated
                            return Task(id: d.documentID,
                                        name: d["name"] as? String ?? "",
                                        assignee: d["assignee"] as? String ?? "",
                                        desc: d["desc"] as? String ?? "",
                                        priority: d["priority"] as? String ?? "",
                                        dueDate: d["dueDate"] as? String ?? ""
                            
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
                
                self.getData()
                print("Success")
            }
    }
}
