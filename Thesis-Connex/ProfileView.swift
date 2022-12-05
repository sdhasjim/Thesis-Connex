//
//  ProfileView.swift
//  Thesis-Connex
//
//  Created by Jason Lauwrin on 01/11/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserProfile {
    let uid, username, email, profileImageUrl: String
}

class profileViewModel: ObservableObject {
    @Published var errorMessage = ""
    @Published var userProfile: UserProfile?
    
    init() {
        fetchCurrentUser()
    }
    
    private func fetchCurrentUser() {
        
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
            
//            self.errorMessage = "123"
            
            guard let data = snapshot?.data() else {
                self.errorMessage = "No data found"
                return
            }
            
//            self.errorMessage = "Data: \(data.description)"
            let uid = data["uid"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            let profileImageUrl = data["profileImageUrl"] as? String ?? ""
            let username = data["username"] as? String ?? ""
            self.userProfile = UserProfile(uid: uid, username: username, email: email, profileImageUrl: profileImageUrl)
            
//            self.errorMessage = chatUser.profileImageUrl
        }
    }

}

struct ProfileView: View {
    @State var selectedTab = "profile"
    @State var shouldShowImagePicker = false
    
    @ObservedObject private var vm = profileViewModel()


    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    Spacer(minLength: 40)
                    Button {
                        shouldShowImagePicker.toggle()
                    } label: {
                        VStack {
                            if let image = self.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 128, height: 128)
                                    .scaledToFill()
                                    .cornerRadius(64)
                            } else {
                                
//                                Image(systemName: "person.fill")
//                                    .font(.system(size: 64))
//                                    .padding()
//                                    .foregroundColor(Color(.label))
                                WebImage(url: URL(string: vm.userProfile?.profileImageUrl ?? ""))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipped()
                                    .cornerRadius(50)
                                    .overlay(RoundedRectangle(cornerRadius: 44)
                                        .stroke(Color(.label), lineWidth: 1)
                                    )
                                    .shadow(radius: 5)

                            }
                        }
                        .overlay(RoundedRectangle(cornerRadius: 64).stroke(Color.black, lineWidth: 3))
                    }
                    Text(vm.userProfile?.username ?? "")
                    Text(vm.userProfile?.email ?? "")
                }
                
                Button {
//                    handleAction()
                } label: {
                    HStack {
                        Spacer()
                        Text("Log Out")
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .font(.system(size: 14, weight: .semibold))
                        Spacer()
                    }
                    .background(Color.red)
                    .cornerRadius(10)
                }
                .padding()
//                Text(self.loginStatusMessage)
//                    .foregroundColor(.red)
            }
//            .navigationTitle("Create Account")
            .background(Color("yellow_tone")
                .ignoresSafeArea())
        }
        
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
        }
    }


    @State var image: UIImage?
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}


