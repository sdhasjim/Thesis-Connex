//
//  ScoringDetailView.swift
//  Thesis-Connex
//
//  Created by Jason Lauwrin on 21/12/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ScoringDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    let user: User
    let project: Project
    
    @ObservedObject var scoreVM: ScoreViewModel

    @State var userScore: Int
    @State var userStart: String
    @State var userStop: String
    @State var userContinue: String
    @State var isEmpty: Bool
    
    init(user: User, project: Project, scoreVM: ScoreViewModel)
    {
        let score       = scoreVM.scores.first(where: { $0.toUserID == user.uid })
        
        self.user       = user
        self.project    = project
        self.scoreVM    = scoreVM
        
        _userScore      = State(initialValue: score?.score ?? 0)
        _userStart      = State(initialValue: score?.userStart ?? "")
        _userStop       = State(initialValue: score?.userStop ?? "")
        _userContinue   = State(initialValue:score?.userContinue ?? "")
        _isEmpty        = State(initialValue: score == nil)
    }
    
    var scoreDetailNavBar : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
    }){
        
        HStack{
            Image(systemName: "chevron.left")
                .font(.system(size: 8, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 20, height: 20)
                .background(Color("brown_tone"))
                .clipShape(Circle())
                .frame(alignment: .topLeading)
            
            Text("  Back")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color("brown_tone"))
                .frame(width: 275, alignment: .topLeading)
            
            Button {
                scoreVM.addData(projectID: project.id, userID: user.id, score: userScore, userStart: userStart, userStop: userStop, userContinue: userContinue)
                self.presentationMode.wrappedValue.dismiss()
//                scoreStatus = true
            } label: {
                Text("Save")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color("brown_tone"))
            }
            .frame(alignment: .trailing)
        }.offset(x: 5)
        
        }
    }
    
    var body: some View {
        ZStack{
            Color("yellow_tone").ignoresSafeArea()
            ScrollView {
                VStack(alignment: .center, spacing: 20) {
                    
                    WebImage(url: URL(string: user.profileImageUrl))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100, alignment: .center)
                        .clipped()
                        .cornerRadius(100)
                        .overlay(RoundedRectangle(cornerRadius: 100)
                            .stroke(Color(.label), lineWidth: 1)
                        )
                        .shadow(radius: 5)
                    Text(user.username)
                        .font(.system(size: 20, weight: .bold))
                        .frame(width: 360, alignment: .center)
                    Text("In project: \(project.name)")
                        .font(.system(size: 16, weight: .semibold))
                    
                    VStack{
                        Text(" Give Score: \(userScore)")
                            .frame(width: 360, alignment: .leading)
                        Picker(selection: $userScore, label: Text("Select a number")) {
                            ForEach(1..<101) {
                                Text("\($0)").tag($0)
                            }
                        }.pickerStyle(.wheel)
                        
                        VStack{
                            Text(" Let's give feedback to your friends")
                                .font(.system(size: 17, weight: .regular))
                                .frame(width: 360, alignment: .leading)
                                .offset(y:-20)
                            Text(" Start")
                                .frame(width: 360, alignment: .leading)
                            TextField("What user need to start", text: $userStart)
                                .padding(9)
                                .foregroundColor(.black)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .frame(width: 360, alignment: .leading)
                            Text(" Stop")
                                .frame(width: 360, alignment: .leading)
                            TextField("What user need to stop", text: $userStop)
                                .padding(9)
                                .foregroundColor(.black)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .frame(width: 360, alignment: .leading)
                            Text(" Continue")
                                .frame(width: 360, alignment: .leading)
                            TextField("What user need to continue", text: $userContinue)
                                .padding(9)
                                .foregroundColor(.black)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .frame(width: 360, height: 200, alignment: .topLeading)
                        }.offset(y: 60)
                    }.offset(y: 20)
                }.padding()
            }
            .frame(maxWidth: .infinity)
        }.navigationBarTitleDisplayMode(.inline)
        
        //ini headernya
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: scoreDetailNavBar)
        
        //make navbar color to white
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(
            Color("yellow_tone"),
            for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .preferredColorScheme(.light)
        
        .toolbar(.hidden, for: .tabBar)
    }
}

//struct ScoringDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScoringDetailView(user: User(id: "pZ08hZ1PI4S4DNQUaDR86ruZzq53", uid: "pZ08hZ1PI4S4DNQUaDR86ruZzq53", username: "sdhasjim", email: "sdhasjim@gmail.com", profileImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/thesis-connex.appspot.com/o/pZ08hZ1PI4S4DNQUaDR86ruZzq53?alt=media&token=27929f7f-9f59-4dd3-a246-66cdaeafa9d3"))
//    }
//}

