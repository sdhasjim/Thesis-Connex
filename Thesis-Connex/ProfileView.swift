//
//  ProfileView.swift
//  Thesis-Connex
//
//  Created by Jason Lauwrin on 01/11/22.
//

import SwiftUI
import SDWebImageSwiftUI

class profileViewModel: ObservableObject {
    @Published var errorMessage = ""
    @Published var profileUser: ProfileUser?
    
    init() {
        
        DispatchQueue.main.async {
            self.isCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        }
        fetchCurrentUser()
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
            
//            self.errorMessage = "123"
            
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
                                WebImage(url: URL(string: vm.profileUser?.profileImageUrl ?? ""))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipped()
                                    .cornerRadius(100)
                                    .overlay(RoundedRectangle(cornerRadius: 100)
                                        .stroke(Color(.label), lineWidth: 1)
                                    )
                                    .shadow(radius: 5)

                            }
                        }
                        .overlay(RoundedRectangle(cornerRadius: 64).stroke(Color.black, lineWidth: 3))
                    }
                    Text(vm.profileUser?.username ?? "")
                    Text(vm.profileUser?.email ?? "")
                }
                
                Button {
                    vm.handleSignOut()
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
        
        .fullScreenCover(isPresented: $vm.isCurrentlyLoggedOut, onDismiss: nil) {
            LoginView(didCompleteLoginProcess: {
                self.vm.isCurrentlyLoggedOut = false
                self.vm.fetchCurrentUser()
            })
        }

    }


    @State var image: UIImage?
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}


