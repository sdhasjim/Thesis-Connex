//
//  ProjectViewModel.swift
//  Thesis-Connex
//
//  Created by Samuel Dennis on 19/12/22.
//

import Foundation
import Firebase
import FirebaseFirestore

class ProjectViewModel: ObservableObject {
    
    @Published var projects = [Project]()
    @Published var collabProjects = [Project]()
    
    func updateData(projectToUpdate: Project) {
        
        let db = FirebaseManager.shared.firestore
        
        // Set the data to update
//        db.collection("projects").document(projectToUpdate.id).setData(["name": "updated project name", "desc": "some desc"])
        db.collection("projects").document(projectToUpdate.id).setData(["name": "updated project name"], merge: true)
        db.collection("projects").document(projectToUpdate.id).setData(["name": "Updated: \(projectToUpdate.name)"], merge: true) { error in
            
            if error == nil {
                // Get the new data
                self.getDataFromUser(status: "unfinished")
//                self.getAllUserData()
            }
        }
        
    }
    
    func updateExistingDataStatus(projectToUpdate: Project, status: String) {
        
        let db = FirebaseManager.shared.firestore
        
        // Set the data to update
        db.collection("projects").document(projectToUpdate.id).setData(
            ["status": status
            
            ]
            , merge: true) { error in
            
//                if error == nil {
//                    self.getDataFromStatusAndProjectID(projectID: <#T##String#>, status: status)
//                }
                if error == nil {
                    self.getDataFromUser(status: "unfinished")
//                    self.getAllUserData()
                }
//                ,
//               let index = self.tasks.firstIndex(of: taskToUpdate){
//
//                self.tasks[index].status = status
//            }
        }
        
    }
    
    func updateExistingData(projectToUpdate: Project, name: String, desc: String, collaborator: [String]) {
        
        let db = FirebaseManager.shared.firestore
        
        // Set the data to update
        db.collection("projects").document(projectToUpdate.id).setData(["name": name, "desc": desc, "collaborator": collaborator], merge: true) { error in
            
//        }
//        db.collection("projects").document(projectToUpdate.id).setData(["name": "updated project name"], merge: true)
//        db.collection("projects").document(projectToUpdate.id).setData(["name": "Updated: \(projectToUpdate.name)"], merge: true) { error in
            
            if error == nil {
                self.getDataFromUser(status: "unfinished")
//                self.getAllUserData()
            }
//                ,
//               let index = self.projects.firstIndex(of: projectToUpdate){
//
//                self.projects[index].name = name
//                self.projects[index].desc = desc
//                self.projects[index].collaborator = collaborator
//            }
        }
        
    }
    
    func deleteData(projectToDelete: Project) {
        // Get a reference to the database
        let db = FirebaseManager.shared.firestore
        
        // Specify the document to delete
        db.collection("projects").document(projectToDelete.id).delete { error in
            // Check for errors
            
            if error == nil {
                // No errors
                
                //Update the UI from the main thread
                DispatchQueue.main.async {
                    
                    // Remove the project that was just deleted
                    self.projects.removeAll { project in
                        // Check for the project to remove
                        
                        return project.id == projectToDelete.id
                    }
                }
                
            }
        }
    }
    
    func addData(name: String, desc: String, owner: String) {
        // Get a reference to the database
        
        let db = FirebaseManager.shared.firestore
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let email = FirebaseManager.shared.auth.currentUser?.email else { return }
        
        let projectData = ["uid": uid, "name": name, "desc": desc, "owner": owner, "collaborator": [email], "status": "unfinished"] as [String : Any]
        
        // Add a document to a collection

        db.collection("projects")
            .addDocument(data: projectData) { err in
                if let err = err {
                    print(err)
                    return
                }
                
                self.getDataFromUser(status: "unfinished")
//                self.getAllUserData()
                print("Success")
            }
    }
    
    func getAllUserData() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let email = FirebaseManager.shared.auth.currentUser?.email else { return }
        
        let db = FirebaseManager.shared.firestore
        
        let projectRef = db.collection("projects")
        
        let query =
        projectRef
            .whereField("collaborator", arrayContains: email)
        
        
        query.addSnapshotListener { querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                    DispatchQueue.main.async {
                        self.projects = querySnapshot!.documents.map { d in
                            
                            // Create a project for each document iterated
                            return Project(id: d.documentID,
                                           name: d["name"] as? String ?? "",
                                           desc: d["desc"] as? String ?? "",
                                           collaborator: d["collaborator"] as? [String] ?? [String](),
                                           status: d["status"] as? String ?? "",
                                           uid: d["uid"] as? String ?? "",
                                           owner: d["owner"] as? String ?? ""
                            )
                        }
                    }
            }
        }
    }

    
    func getDataFromUser(status: String) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let email = FirebaseManager.shared.auth.currentUser?.email else { return }
        
        let db = FirebaseManager.shared.firestore
        
        let projectRef = db.collection("projects")
        
        let query =
        projectRef
            .whereField("collaborator", arrayContains: email)
            .whereField("status", isEqualTo: status)
        
        
        query.addSnapshotListener { querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                    DispatchQueue.main.async {
                        self.projects = querySnapshot!.documents.map { d in
                            
                            // Create a project for each document iterated
                            return Project(id: d.documentID,
                                           name: d["name"] as? String ?? "",
                                           desc: d["desc"] as? String ?? "",
                                           collaborator: d["collaborator"] as? [String] ?? [String](),
                                           status: d["status"] as? String ?? "",
                                           uid: d["uid"] as? String ?? "",
                                           owner: d["owner"] as? String ?? ""
                            )
                        }
                    }
            }
        }
    }
    
    func getData() {
        // Get a reference to the database
        
        let db = FirebaseManager.shared.firestore
        
        // Read the documents at a specific path
        db.collection("projects").addSnapshotListener { snapshot, error in
            
            // Check for errors
            if error == nil {
                // No error
                if let snapshot = snapshot {
                    
                    // Update the list property in the main thread
                    DispatchQueue.main.async {
                        // Get all the documents and create Projects
                        self.projects = snapshot.documents.map { d in
                            
                            // Create a project for each document iterated
                            return Project(id: d.documentID,
                                           name: d["name"] as? String ?? "",
                                           desc: d["desc"] as? String ?? "",
                                           collaborator: d["collaborator"] as? [String] ?? [String](),
                                           status: d["status"] as? String ?? "",
                                           uid: d["uid"] as? String ?? "",
                                           owner: d["owner"] as? String ?? ""
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
    
}
