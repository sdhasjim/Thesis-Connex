//
//  ScoringView.swift
//  Thesis-Connex
//
//  Created by Jason Lauwrin on 21/12/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ScoringView: View {
    
    let project: Project
//    let users: [User]
    @ObservedObject var profileVM: ProfileViewModel
    @ObservedObject var scoreVM: ScoreViewModel
    @ObservedObject var projectVM: ProjectViewModel
    @State var selectedTab = "task"
    @State var scoreStatus: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var scoringViewNavbar : some View {
        HStack{
            Text("\(project.name)  Scoring")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color("brown_tone"))
                .frame(width: 300,alignment: .topLeading)
            
            Button{
                projectVM.updateExistingDataStatus(projectToUpdate: project, status: "finished")
                presentationMode.wrappedValue.dismiss()
            } label: {
                VStack {
                    Text("Finish")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color("brown_tone"))
                }
            }
        }.offset(x: 5)
    }
    
    var body: some View {
        ZStack{
            Color("yellow_tone").ignoresSafeArea()
            ScrollView(){
                VStack{
                    if profileVM.collabUsers.count != 0 {
                        ForEach(profileVM.collabUsers) { item in
                            VStack{
                                NavigationLink{
                                    ScoringDetailView(user: item, project: project, scoreVM: scoreVM)
                                } label: {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundColor(scoreVM.scores.contains(where: { $0.toUserID == item.uid }) ? .green : .white)
                                            .shadow(radius: 1.5)
                                        VStack{
                                            HStack{
                                                WebImage(url: URL(string: item.profileImageUrl))
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 50, height: 50)
                                                    .clipped()
                                                    .cornerRadius(50)
                                                    .overlay(RoundedRectangle(cornerRadius: 50)
                                                        .stroke(Color(.label), lineWidth: 1)
                                                    )
                                                
                                                Text(item.email)
                                                    .font(.system(size: 18, weight: .bold))
                                                    .foregroundColor(.black)
                                                    .frame(alignment: .leading)
                                                Spacer()
                                            }.padding()
                                        }
                                    }
                                    .frame(width: 340, height: 80).offset(y: 20)
                                }
                            }
                        }
                    }
                    else {
                        // TODO: Create UI if they finish the project alone
                        VStack {
                            Text("Congratulation! You have finished the project single-handedly!")
                        }
                    }

                }
            }.frame(width: 360)
            .frame(maxHeight: .infinity)
        }
        .navigationBarTitleDisplayMode(.inline)
        
        //ini headernya
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: scoringViewNavbar)
        
        //make navbar color to white
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(
            Color("yellow_tone"),
            for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .preferredColorScheme(.light)
        .onAppear {
            for collab in project.collaborator {
                profileVM.fetchUserDataFromEmail(email: collab)
            }
            scoreVM.getOutcomingDataFromProjectID(projectID: project.id)
        }
    }
}

//struct ScoringView_Previews: PreviewProvider {
//    static var previews: some View {
////        ScoringView(project: Project(id: "ZVkYGZYNpGxhf9rLkjzu", name: "Project Rama", desc: "", collaborator: "", uid: "pZ08hZ1PI4S4DNQUaDR86ruZzq53", owner: <#T##String#>)
//    }
//}

