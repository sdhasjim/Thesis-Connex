//
//  ScoringView.swift
//  Thesis-Connex
//
//  Created by Jason Lauwrin on 21/12/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ScoringView: View {
    
    let project: Project?
    let collaborator: [String]
//    let users: [User]
    @ObservedObject var vm: ProfileViewModel
    @ObservedObject var scoreVM: ScoreViewModel
    
    @State var selectedTab = "task"
//    @State var scoreStatus = false
    
    @State var scoreStatus: Bool = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var scoringViewNavbar : some View {
        VStack{
            HStack{
                Text("\(project!.name)  Scoring")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color("brown_tone"))
                    .frame(alignment: .topLeading)
            }.offset(x: 5)
        }
    }
    
    var body: some View {
        ZStack{
            Color("yellow_tone").ignoresSafeArea()
            ScrollView(){
                ForEach(vm.collabUsers) { item in
                    VStack{
                        NavigationLink{
                            ScoringDetailView(user: item, project: project!, scoreVM: scoreVM, scoreStatus: $scoreStatus)
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundColor(.white)
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
//
                                        Spacer()
//
//                                        if scoreStatus == false {
//                                            Text("Unfinished")
//                                                .font(.system(size: 13, weight: .semibold))
//                                        } else {
//                                            Text("Finished")
//                                                .font(.system(size: 13, weight: .semibold))
//                                                .foregroundColor(.green)
//                                        }

//                                            .frame(width: 260, alignment: .trailing)
                                    }.padding()
                                }
                            }.frame(width: 340, height: 80).offset(y: 20)
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
            // Fetch user data
//            print("collaborator \(collaborator)")
            for collab in collaborator {
                print("1. usernya:\(collab)")
//                print(vm.collabUsers)
                vm.fetchUserDataFromEmail(email: collab)
//                print(vm.collabUsers)
            }
//            vm.fet
//            vm.fetchUserDataFromEmail(email: collaborator)
//            vm.fetchUserForCollab(collaborator: collaborator)
//            vm.fetchUserDataFromEmail(email: <#T##String#>)
            
//            print(vm.users)
        }
    }
}

//struct ScoringView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScoringView(project: Project(id: <#T##String#>, name: <#T##String#>, desc: <#T##String#>, collaborator: <#T##[String]#>, uid: <#T##String#>, owner: <#T##String#>), collaborator: ["test", "mantab"], vm: ProfileViewModel())
//    }
//}

