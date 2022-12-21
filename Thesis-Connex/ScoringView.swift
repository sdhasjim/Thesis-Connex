//
//  ScoringView.swift
//  Thesis-Connex
//
//  Created by Jason Lauwrin on 21/12/22.
//

import SwiftUI

struct ScoringView: View {
    @State var selectedTab = "task"
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var scoringViewNavbar : some View { Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }){
            
            VStack{
                HStack{
                    Image(systemName: "chevron.left")
                        .font(.system(size: 8, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 20, height: 20)
                        .background(Color("brown_tone"))
                        .clipShape(Circle())
                        .frame(alignment: .topLeading)
                    
                    Text("  Scoring")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color("brown_tone"))
                        .frame(alignment: .topLeading)
                }.offset(x: 5)
            }
        }
        
    }
    
    var body: some View {
        ZStack{
            Color("yellow_tone").ignoresSafeArea()
            ScrollView(){
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
                                    
                                    Text("People 1")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.black)
                                        .frame(width: 260, alignment: .leading)
                                }
                            }
                        }.frame(width: 340, height: 80).offset(y: 20)
                    }.frame(width: 350, height: 520, alignment: .top)
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
    }
}

struct ScoringView_Previews: PreviewProvider {
    static var previews: some View {
        ScoringView()
    }
}

