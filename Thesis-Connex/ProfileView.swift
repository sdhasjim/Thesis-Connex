//
//  ProfileView.swift
//  Thesis-Connex
//
//  Created by Jason Lauwrin on 01/11/22.
//

import SwiftUI

struct ProfileView: View {
    @State var selectedTab = "profile"
    @State var shouldShowImagePicker = false

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
                                
                                Image(systemName: "person.fill")
                                    .font(.system(size: 64))
                                    .padding()
                                    .foregroundColor(Color(.label))
                            }
                        }
                        .overlay(RoundedRectangle(cornerRadius: 64).stroke(Color.black, lineWidth: 3))
                    }
                    Text("Samuel Dennis")
                    Text("sdhasjim@gmail.com")
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


