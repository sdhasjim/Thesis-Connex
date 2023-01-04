//
//  InviteCollaborator.swift
//  Thesis-Connex
//
//  Created by Samuel Dennis on 22/12/22.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseFirestore
import Firebase

class CreateNewMessageViewModel: ObservableObject {

    @Published var users = [User]()
    @Published var errorMessage = ""

    init(collaborator: [String], projectUID: String) {
        fetchAllUsers(collaborator: collaborator, projectUID: projectUID)
    }

    private func fetchAllUsers(collaborator: [String], projectUID: String) {
        FirebaseManager.shared.firestore.collection("users")
            .addSnapshotListener { documentsSnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to fetch current users: \(error)"
                    print("Failed to fetch users: \(error)")
                    return
                }

                documentsSnapshot?.documents.forEach({ snapshot in
                    let data = snapshot.data()
                    let uid = data["uid"] as? String ?? ""
                    let username = data["username"] as? String ?? ""
                    let email = data["email"] as? String ?? ""
                    let profileImageUrl = data["profileImageUrl"] as? String ?? ""
                    let user = User(id: uid, uid: uid, username: username, email: email, profileImageUrl: profileImageUrl)

                    if user.uid != FirebaseManager.shared.auth.currentUser?.uid && !collaborator.contains(where: { $0 == user.email
                    }) {
                        self.users.append(user)
                    }
                })
            }
    }
}

struct InviteCollaborator: View {
    
    let didSelectNewUser: (User) -> ()
    
    @Environment(\.presentationMode) var presentationMode
    
    let project: Project?
    
    @ObservedObject var vm: CreateNewMessageViewModel
    @ObservedObject var projectVM: ProjectViewModel
    @ObservedObject var profileVM: ProfileViewModel
    
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

struct InviteCollaborator_Previews: PreviewProvider {
    static var previews: some View {
//        BoardView(projectVM: ProjectViewModel(), taskVM: TaskViewModel())
        BoardDetailView(project: Project(id: "AMtXnHmzutlqKvQYHjNe", name: "OOP", desc: "Blablabla", collaborator: ["test", "mantap"], status: "unfinished", uid: "pZ08hZ1PI4S4DNQUaDR86ruZzq53", owner: "test"), vm: ProjectViewModel(), profileVM: ProfileViewModel(), scoreVM: ScoreViewModel())
    }
}
