//
//  AssignTask.swift
//  Thesis-Connex
//
//  Created by Samuel Dennis on 04/01/23.
//

import SwiftUI

import SwiftUI
import SDWebImageSwiftUI
import FirebaseFirestore
import Firebase

class AssignTaskViewModel: ObservableObject {

    @Published var users = [User]()
    @Published var errorMessage = ""

    init(collaborator: [String]) {
        for collab in collaborator {
            fetchUserDataFromEmail(email: collab)
        }
    }
    
    func fetchUserDataFromEmail(email: String) {
        self.users.removeAll()
        
        let db = FirebaseManager.shared.firestore
        
        let userRef = db.collection("users")
        
        let query =
        userRef
            .whereField("email", isEqualTo: email)
        
        query.addSnapshotListener { documentsSnapshot, error in
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
                
                self.users.append(user)
            })
        }
    }

//    private func fetchAllUsersFromCollaborator() {
//        FirebaseManager.shared.firestore.collection("users")
//            .addSnapshotListener { documentsSnapshot, error in
//                if let error = error {
//                    self.errorMessage = "Failed to fetch current users: \(error)"
//                    print("Failed to fetch users: \(error)")
//                    return
//                }
//
//                documentsSnapshot?.documents.forEach({ snapshot in
//                    let data = snapshot.data()
//                    let uid = data["uid"] as? String ?? ""
//                    let username = data["username"] as? String ?? ""
//                    let email = data["email"] as? String ?? ""
//                    let profileImageUrl = data["profileImageUrl"] as? String ?? ""
//                    let user = User(id: uid, uid: uid, username: username, email: email, profileImageUrl: profileImageUrl)
//
//                    self.users.append(user)
//                })
//            }
//    }
}

struct AssignTask: View {
    
    let didSelectNewUser: (User) -> ()
    
    @Environment(\.presentationMode) var presentationMode
    
//    let project: Project?
    
    @ObservedObject var vm: AssignTaskViewModel
//    @ObservedObject var projectVM: ProjectViewModel
//    @ObservedObject var profileVM: ProfileViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                ForEach(vm.users) { user in
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        didSelectNewUser(user)
                    } label: {
                        HStack {
                            WebImage(url: URL(string: user.profileImageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipped()
                                .cornerRadius(50)
                                .overlay(RoundedRectangle(cornerRadius: 50)
                                    .stroke(Color(.label), lineWidth: 1)
                                )
                            Text(user.email)
                                .foregroundColor(Color(.label))
                            Spacer()
                        }.padding(.horizontal)
                    }
                    Divider()
                        .padding(.vertical, 8)
                }
            }.navigationTitle("New Message")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Cancel")
                        }
                    }
                }
        }
    }
}


struct AssignTask_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(projectVM: ProjectViewModel(), taskVM: TaskViewModel(), profileVM: ProfileViewModel(), scoreVM: ScoreViewModel())
    }
}
