//
//  BoardView.swift
//  Thesis-Connex
//
//  Created by Jason Lauwrin on 01/11/22.
//

import SwiftUI


struct NetworkConnection: View{
    @ObservedObject var monitor = NetworkMonitorConnex()
    @State private var showAlertSheet = false
    
    var body: some View{
        ZStack{
            Color("beidge_tone").ignoresSafeArea()
            VStack{
                Image("inet2")
                
                Button(action: {self.showAlertSheet = true}) {
                    Image("inet_button")
                        .frame(width: 115, height: 150)
                }.offset(y: -30)
            }
            .alert(isPresented: $showAlertSheet, content: {
                if monitor.isConnected{
                    return Alert(title: Text("Success!"), message: Text("The network request was successful"), dismissButton: .default(Text("Ok")))
                }
                return Alert(title: Text("No Internet Connection!"), message: Text("Please Enable Wifi or Celular Data"), dismissButton: .default(Text("Cancel")))
            })
        }
    }
}



struct BoardView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var searchText = ""
    @State var selectedTab = "board"
    @ObservedObject var monitor = NetworkMonitorConnex()
    @State private var showAlertSheet = false
    @State var customAlert = false
    @State var HUD = false
    @State var projectName = ""
    
    var mainNavBar : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
    }){
        HStack{
            Text("  Your Workspace")
                .font(.system(size: 25, weight: .bold))
                .foregroundColor(Color("brown_tone"))
                .frame(width: 300, alignment: .leading)
            Button(action: {
                newProjectView()
            }, label: {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(Color("brown_tone"))
                    .frame(width: 55, alignment: .trailing)
            })
            }
        }
    }
    
    func newProjectView(){
        //ini alert uy
        let alert = UIAlertController(title: "Create New Project", message: "Let's create your project name", preferredStyle: .alert)
        
        
        alert.addTextField{(name) in
            name.isSecureTextEntry = false
            name.placeholder = "Project Name"
        }
        
        let create = UIAlertAction(title: "Create", style: .default){(_) in
            //do yiur own stuff
            
            //retrieving password
            projectName = alert.textFields![0].text!
        }
        
        let cancel = UIAlertAction(title: "cancel", style: .destructive){(_) in
            //same
        }
        
        //adding into alertview
        alert.addAction(cancel)
        
        alert.addAction(create)
        
        //presenting alertView
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: {
            //do your own
        })
    }
    
    var body: some View {
        
        NavigationView{
            ZStack(alignment: .bottom, content: {
                Color("yellow_tone").ignoresSafeArea()
                
                if monitor.isConnected{
                    VStack{
                        Text("\(searchText)")
                            .searchable(text: $searchText)
                            .navigationBarBackButtonHidden(true)
                            .navigationBarItems(leading: mainNavBar)
                        ScrollView(){
                            VStack{
                                NavigationLink(destination: InsideBoardView(), label: {
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
                                            
                                            NavigationLink(destination: LoginView(), label: {
                                                Image(systemName: "square.and.pencil").font(.system(size: 20))
                                            }).offset(x: 140, y: -15)
                                            
//                                            Button(action: {
//                                                //ini isi den
//                                            }){
//                                                Image(systemName: "square.and.pencil").font(.system(size: 20))
//                                            }.offset(x: 140, y: -15)
                                            
                                            
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
                }else{
                    NetworkConnection()
                }
                
//                CustomTabBar(selectedTab: $selectedTab)
            }).frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(
            Color("yellow_tone"),
            for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .preferredColorScheme(.light)
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
    }
}

