//
//  ScoringDetailView.swift
//  Thesis-Connex
//
//  Created by Jason Lauwrin on 21/12/22.
//

import SwiftUI

struct ScoringDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var userScore = ""
    @State var userStart = ""
    @State var userStop = ""
    @State var userContinue = ""
    
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
                //
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
                VStack(alignment: .leading, spacing: 20) {
                    
                    Image(systemName: "person.circle")
                        .font(.system(size: 80))
                        .frame(width: 360, alignment: .center)
                    Text("Person 1")
                        .font(.system(size: 20, weight: .bold))
                        .frame(width: 360, alignment: .center)
                    
                    VStack{
                        Text(" Give Score")
                            .frame(width: 360, alignment: .leading)
                        TextField("Score", text: $userScore)
                            .padding(9)
                            .foregroundColor(.black)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .frame(width: 360, alignment: .leading)
                        
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

struct ScoringDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ScoringDetailView()
    }
}

