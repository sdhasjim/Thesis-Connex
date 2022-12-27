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
    @State var projectName = ""
    @State var projectDesc = ""
    @ObservedObject var projectVM: ProjectViewModel
    @ObservedObject var vm: ProfileViewModel
    @ObservedObject var taskVM: TaskViewModel

    var body: some View {
        
        NavigationView{
            ZStack(alignment: .top, content: {
                Color("yellow_tone").ignoresSafeArea()
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
                        Text(vm.user?.username ?? "").foregroundColor(Color("brown_tone"))
                        Text(vm.user?.email ?? "").foregroundColor(Color("brown_tone"))
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
                    .frame(width: 200)
                    
                    VStack{
                        Text("Project History:")
                            .font(.system(size: 25, weight: .semibold))
                            .frame(width: 350, height: 50, alignment: .bottomLeading)
                            .offset(x:10)
                            .foregroundColor(Color("brown_tone"))
                        ForEach (projectVM.projects) { item in
                            NavigationLink  {
                                ProjectDetailView(project: item, taskVM: taskVM, projectName: item.name)
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 25)
                                        .foregroundColor(.white)
                                        .shadow(radius: 1.5)
                                        .frame(width: 345, height: 80)
                                        .foregroundColor(.black)
                                    VStack {
                                        Text(item.name)
                                            .font(.system(size: 15, weight: .bold))
                                            .frame(width: 320, height: 20, alignment: .bottomLeading)
                                            .offset(y: 5)
                                        Text(item.desc)
                                            .frame(width: 320, height: 50, alignment: .topLeading)
                                            .multilineTextAlignment(.leading)
                                    }
                                }
                                
                            }


                        }
                        
                        .frame(height: 90)
                    }
//                    .frame(height: 700)
//                    .offset(y: -40)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .scrollIndicators(.hidden)
            })
        }

    }


    @State var image: UIImage?
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(projectVM: ProjectViewModel(), taskVM: TaskViewModel(), profileVM: ProfileViewModel())
    }
}


