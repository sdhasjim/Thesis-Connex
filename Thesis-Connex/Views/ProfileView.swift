//
//  ProfileView.swift
//  Thesis-Connex
//
//  Created by Jason Lauwrin on 01/11/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    @State var selectedTab = "profile"
    @State var shouldShowImagePicker = false
    
    @ObservedObject var vm: ProfileViewModel

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
                                WebImage(url: URL(string: vm.user?.profileImageUrl ?? ""))
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
                    Text(vm.user?.username ?? "")
                    Text(vm.user?.email ?? "")
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
        .onAppear {
            vm.fetchCurrentUser()
        }

    }


    @State var image: UIImage?
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(vm: ProfileViewModel())
    }
}


