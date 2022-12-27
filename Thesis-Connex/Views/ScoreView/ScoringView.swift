//
//  ScoringView.swift
//  Thesis-Connex
//
//  Created by Jason Lauwrin on 21/12/22.
//

import SwiftUI

struct ScoringView: View {
    
    let collaborator: [String]
//    let users: [User]
    @ObservedObject var vm: ProfileViewModel
    
    @State var selectedTab = "task"
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var scoringViewNavbar : some View {
        VStack{
            HStack{
                Text("  Scoring")
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
                ForEach(vm.users) { item in
                    VStack{
                        NavigationLink{
                            ScoringDetailView()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundColor(.white)
                                    .shadow(radius: 1.5)
                                VStack{
                                    HStack{
                                        Image(systemName: "person.circle")
                                            .foregroundColor(.black)
                                            .font(.system(size: 30))
                                            .frame(width: 70, alignment: .center)
                                        
                                        Text("item.email")
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(.black)
                                            .frame(width: 260, alignment: .leading)
                                    }
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
//            for collab in collaborator {
//                print(collab)
//                vm.fetchUserDataFromEmail(email: collab)
//            }
//            vm.fetchUserDataFromEmail(email: collaborator)
//            vm.fetchUserForCollab(collaborator: collaborator)
//            vm.fetchUserDataFromEmail(email: <#T##String#>)
            
            print(vm.users)
        }
    }
}

//struct ScoringView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScoringView(collaborator: ["test", "mantab"], users: <#[User]#>, vm: ProfileViewModel())
//    }
//}

