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
                                        assignee: d["assignee"] as? String ?? "")
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
