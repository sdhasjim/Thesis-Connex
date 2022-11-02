//
//  BoardView.swift
//  Thesis-Connex
//
//  Created by Jason Lauwrin on 01/11/22.
//

import SwiftUI

struct BoardView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var searchText = ""
    @State var selectedTab = "board"
    
    var mainNavBar : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
    }){
        HStack{
            Text("  Your Workspace")
                .font(.system(size: 25, weight: .bold))
                .foregroundColor(Color("brown_tone"))
                .frame(width: 300, alignment: .leading)
            NavigationLink(destination: ProfileView(), label: {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(Color("brown_tone"))
                    .frame(width: 55, alignment: .trailing)
            })
            }
        }
    }
    
    var body: some View {
        
        NavigationView{
            ZStack(alignment: .bottom, content: {
                Color("yellow_tone").ignoresSafeArea()
                VStack{
                    Text("\(searchText)")
                        .searchable(text: $searchText)
                        .navigationBarBackButtonHidden(true)
                        .navigationBarItems(leading: mainNavBar)
                    ScrollView(){
                        VStack{
                            NavigationLink(destination: ProfileView(), label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 25)
                                        .foregroundColor(.white)
                                        .shadow(radius: 1.5)
                                        .frame(width: 350, height: 150)
                                        .foregroundColor(.black)
                                    VStack{
                                        Text("Board 1")
                                            .font(.system(size: 15, weight: .bold))
                                            .frame(width: 300, height: 0, alignment: .leading)
                                        Text("The board's key purpose “is to ensure the company's prosperity by collectively directing the company's affairs” ")
                                            .font(.system(size: 15, weight: .light))
                                            .multilineTextAlignment(.leading)
                                            .frame(width: 300, height: 80, alignment: .leading)
                                    }
                                }
                            })
                            .frame(width: 450, height: 170)
                            .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 180)
                    }
                }
                
//                CustomTabBar(selectedTab: $selectedTab)
            }).frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
    }
}

