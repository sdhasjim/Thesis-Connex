//
//  ProfileViewModel.swift
//  Thesis-Connex
//
//  Created by Samuel Dennis on 20/12/22.
//

import Foundation

class ProfileViewModel: ObservableObject {
    
    @Published var errorMessage = ""
    @Published var profileUser: ProfileUser?
    
    @Published var users = [ProfileUser]()
    
    init() {
        
        DispatchQueue.main.async {
            self.isCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        }
        fetchCurrentUser()
    }
    
    func fetchUserDataFromEmail(email: [String]) {
        print("Masuk VM Fetch")
//        guard let email = FirebaseManager.shared.auth.currentUser?.email else { return }
        
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
                            
                            // Create a project for each document iterated
                            return ProfileUser(data: ["String" : "Any"]
                            )
                        }
                    }
            }
        }

        
//        query.getDocuments { querySnapshot, err in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                    DispatchQueue.main.async {
//
//                        for d in querySnapshot!.documents {
//                            let data = d.data()
////                            self.users = .init(data)
////                            print(data)
////                            self.users = .init(data)
////                            print(self.profileUser)
//                        }
//
//                    }
//            }
//        }
    }
//    var id: String { uid }
//
//    let uid, username, email, profileImageUrl: String
//
//    init(data: [String: Any]) {
//        self.uid = data["uid"] as? String ?? ""
//        self.email = data["email"] as? String ?? ""
//        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
//        self.username = data["username"] as? String ?? ""
//    }
    
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
            
            self.profileUser = .init(data: data)
        }
    }
    
    @Published var isCurrentlyLoggedOut = false
    
    func handleSignOut() {
        isCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
    }

}
