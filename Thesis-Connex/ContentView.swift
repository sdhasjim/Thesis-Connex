//
//  ContentView.swift
//  Thesis-Connex
//
//  Created by Samuel Dennis on 26/10/22.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("currentPage") var currentPage = 1
    
    var body: some View {
        if currentPage > totalPages{
            TabView{
                Board()
                    .tabItem{
                        Label("Board", systemImage: "doc.circle")
                    }
                
                TaskView()
                    .tabItem{
                        Label("Task", systemImage: "hourglass.circle")
                    }
                
                NotificationView()
                    .tabItem{
                        Label("Notif", systemImage: "bell.circle")
                    }
                
                ProfileView()
                    .tabItem{
                        Label("Profile", systemImage: "person.circle")
                    }
            }.accentColor(Color("brown_tone"))
            
        }else{
            WalkthroughScreen()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Board: View{
    var body: some View{
        BoardView()
    }
}

struct WalkthroughScreen: View{
    
    @AppStorage("currentPage") var currentPage = 1
    
    var body: some View{
        
        //for slide animation
        
        ZStack{
            
            //changing between views
            if currentPage == 1{
                ScreenView(image: "logo", title: "title 1", detail: "isi sendiri", bgColor: Color(.blue))
                    .transition(AnyTransition.opacity.animation(.easeInOut))
            }
            
            if currentPage == 2{
                ScreenView(image: "logo", title: "title 2", detail: "isi sendiri", bgColor: Color.white)
                    .transition(AnyTransition.opacity.animation(.easeInOut))
            }
            
            if currentPage == 3{
                ScreenView(image: "logo", title: "title 3", detail: "isi sendiri", bgColor: Color.white)
                    .transition(AnyTransition.opacity.animation(.easeInOut))
            }
            
            
        }
        .overlay(
            
            //button
            Button(action: {
                //changing views
                withAnimation(.easeInOut){
                    
                    
                    //check
                    if currentPage <= totalPages{
                        currentPage += 1
                    }else{
                        //for app testing only
                        currentPage = 1
                    }
                }
            }, label: {
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(width: 60, height: 60)
                    .background(Color.blue)
                    .clipShape(Circle())
                
                //circular slider
                    .overlay(
                        
                        ZStack{
                            
                            Circle()
                                .stroke(Color.black.opacity(0.04), lineWidth: 4)
                            
                            Circle()
                                .trim(from: 0, to: CGFloat(currentPage) / CGFloat(totalPages))
                                .stroke(Color.gray, lineWidth: 4)
                                .rotationEffect(.init(degrees: -90))
                        }
                        .padding(-15)
                    )
            })
            .padding(.bottom,20)
            
            ,alignment: .bottom
        )
    }
}

struct ScreenView: View {
    
    var image: String
    var title: String
    var detail: String
    var bgColor: Color
    
    @AppStorage("currentPage") var currentPage = 1
    
    var body: some View {
        VStack(spacing: 20){
            
            HStack{
                //showing it only for first page
                if currentPage == 1{
                    Text("Hello member")
                        .font(.title)
                        .fontWeight(.semibold)
                        .kerning(1.4)
                }else{
                    //back button...
                    Button(action: {
                        withAnimation(.easeInOut){
                            currentPage -= 1
                        }
                    }, label: {
                        
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .padding(.vertical,10)
                            .padding(.horizontal)
                            .background(Color.black.opacity(0.4))
                            .cornerRadius(10)
                    })
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation(.easeInOut){
                        currentPage = 4
                    }
                }, label: {
                    Text("Skip")
                        .fontWeight(.semibold)
                        .kerning(1.2)
                })
            }
            .foregroundColor(.black)
            .padding()
            
            Spacer(minLength: 0)
            
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.top)
            
            Text("isi deskripsi")
                .fontWeight(.semibold)
                .kerning(1.3)
                .multilineTextAlignment(.center)
            
            
            //minimum spacing when phone is reducing...
            
            Spacer(minLength: 120)
        }
//        .background(bgColor.cornerRadius(10).ignoresSafeArea())
    }
}


//total page
var totalPages = 3
