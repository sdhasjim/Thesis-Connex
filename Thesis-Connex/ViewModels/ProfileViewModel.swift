//
//  ProfileViewModel.swift
//  Thesis-Connex
//
//  Created by Samuel Dennis on 20/12/22.
//

import Foundation
import SwiftUI

class ProfileViewModel: ObservableObject {
    
    @Published var errorMessage = ""
    //    @Published var profileUser: ProfileUser?
    //
    //    @Published var users = [ProfileUser]()
    @Published var user: User?
    @Published var users = [User]()
    
    init() {
        
        DispatchQueue.main.async {
            self.isCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        }
        fetchCurrentUser()
        fetchAllUsers()
//        fetchUserDataFromEmail(email: email)
    }
    
    //    func fetchUserFromProjectID(projectID: String) {
    //        let db = FirebaseManager.shared.firestore
    //
    //        let projectRef = db.collection("projects")
    //
    //        let query = projectRef.whereField("projectID", isEqualTo: projectID)
    //
    //        query.getDocuments { querySnapshot, err in
    //            if let err = err {
    //                print("Error getting documents: \(err)")
    //            } else {
    //                    DispatchQueue.main.async {
    //                        self.tasks = querySnapshot!.documents.map { d in
    //
    //                            return Task(id: d.documentID,
    //                                        name: d["name"] as? String ?? "",
    //                                        assignee: d["assignee"] as? String ?? "",
    //                                        desc: d["desc"] as? String ?? "",
    //                                        priority: d["priority"] as? String ?? "",
    //                                        dueDate: d["dueDate"] as? String ?? "",
    //                                        status: d["status"] as? String ?? ""
    //
    //                            )
    //                        }
    //                    }
    //            }
    //        }
    //
    //    }
    
    func fetchUserForCollab(collaborator: [String]) {
        FirebaseManager.shared.firestore.collection("users")
            .getDocuments { documentsSnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to fetch current users: \(error)"
                    print("Failed to fetch users: \(error)")
                    return
                }

                documentsSnapshot?.documents.forEach({ snapshot in
                    let data = snapshot.data()
//<<<<<<< Updated upstream
//                    let user = ProfileUser(data: data)
//                    if user.uid != FirebaseManager.shared.auth.currentUser?.uid && !collaborator.contains(where: { $0 == user.email
//=======
//                    let user = ProfileUser(data: data)
                    let uid = data["uid"] as? String ?? ""
                    let username = data["username"] as? String ?? ""
                    let email = data["email"] as? String ?? ""
                    let profileImageUrl = data["profileImageUrl"] as? String ?? ""
                    let user = User(id: uid, uid: uid, username: username, email: email, profileImageUrl: profileImageUrl)
                    if user.uid != FirebaseManager.shared.auth.currentUser?.uid && !collaborator.contains(where: { $0 == user.email
//>>>>>>> Stashed changes
                    }) {
                        self.users.append(user)
                    }
                })
            }
    }

    
    func fetchAllUsers() {
        self.users.removeAll()
        let db = FirebaseManager.shared.firestore
        
        // Read the documents at a specific path
        db.collection("users").getDocuments { documentsSnapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch current users: \(error)"
                print("Failed to fetch users: \(error)")
                return
            }

            documentsSnapshot?.documents.forEach({ snapshot in
                let data = snapshot.data()
//                    let user = ProfileUser(data: data)
                let uid = data["uid"] as? String ?? ""
                let username = data["username"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let profileImageUrl = data["profileImageUrl"] as? String ?? ""
                let user = User(id: uid, uid: uid, username: username, email: email, profileImageUrl: profileImageUrl)
                if user.uid != FirebaseManager.shared.auth.currentUser?.uid
//                    && user.uid != projectUID && !collaborator.contains(where: { $0 == user.email})
                {
                    self.users.append(user)
                }
//                print(self.users)
//                    self.users.append(.init(data: data))
            })
        }
    }
    
    func fetchUserForCollab() {
        self.users.removeAll()
        let db = FirebaseManager.shared.firestore
        
        // Read the documents at a specific path
        db.collection("users").getDocuments { documentsSnapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch current users: \(error)"
                print("Failed to fetch users: \(error)")
                return
            }

            documentsSnapshot?.documents.forEach({ snapshot in
                let data = snapshot.data()
//                    let user = ProfileUser(data: data)
                let uid = data["uid"] as? String ?? ""
                let username = data["username"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let profileImageUrl = data["profileImageUrl"] as? String ?? ""
                let user = User(id: uid, uid: uid, username: username, email: email, profileImageUrl: profileImageUrl)
                if user.uid != FirebaseManager.shared.auth.currentUser?.uid
//                    && user.uid != projectUID && !collaborator.contains(where: { $0 == user.email})
                {
                    self.users.append(user)
                }
//                print(self.users)
//                    self.users.append(.init(data: data))
            })
        }

    }
    
    func fetchUserDataFromEmail(email: String) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.email else { return }
        
        let db = FirebaseManager.shared.firestore
        
        let userRef = db.collection("users")
        
        let query =
        userRef
            .whereField("email", isEqualTo: email)
        
        query.getDocuments { querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                DispatchQueue.main.async {
                    self.users = querySnapshot!.documents.map { d in
                        
                        print(d.documentID)
                        // Create a user for each document iterated
                        return User(
                            id: d.documentID,
                            uid: d["uid"] as? String ?? "",
                            username: d["username"] as? String ?? "",
                            email: d["email"] as? String ?? "",
                            profileImageUrl: d["profileImageUrl"] as? String ?? ""
                        )
                    }
                }
            }
        }
    }
    
    func fetchCurrentUser() {
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return
        }
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user: ", error)
                return
            }
            
            guard let data = snapshot?.data() else {
                self.errorMessage = "No data found"
                return
            }
            
//<<<<<<< Updated upstream
//            self.profileUser = .init(data: data)
//=======
            let uid = data["uid"] as? String ?? ""
            let username = data["username"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            let profileImageUrl = data["profileImageUrl"] as? String ?? ""
            self.user = User(id: uid, uid: uid, username: username, email: email, profileImageUrl: profileImageUrl)
            
//>>>>>>> Stashed changes
        }
    }
    
    @Published var isCurrentlyLoggedOut = false
    
    func handleSignOut() {
        isCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
    }
    
}
