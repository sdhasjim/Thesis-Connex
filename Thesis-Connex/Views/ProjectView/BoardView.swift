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
    @State var projectDesc = ""
    
    @ObservedObject var projectVM: ProjectViewModel
    @ObservedObject var taskVM: TaskViewModel
    
    var mainNavBar : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
    }){
        HStack{
            Text("  Your Project")
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

        let alert = UIAlertController(title: "Create New Project", message: "Let's create your project name", preferredStyle: .alert)
        
        let errorAlert = UIAlertController(title: "Failed to Add New Project", message: "Project Name should be filled", preferredStyle: .alert)
        
        errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            print("Ok tapped")
        }))
        
        let confirmAction = UIAlertAction(title: "Save", style: .default) { _ in
            if let textField = alert.textFields?.first, let text = textField.text {
                projectName = text
                print("Final text: \(projectName)")
            }
            if let textField = alert.textFields?.last, let text = textField.text {
                projectDesc = text
                print("Last text: \(projectDesc)")
            }
            
            if projectName == "" {
                UIApplication.shared.windows.first?.rootViewController?.present(errorAlert, animated: true, completion: {

                })
            }
            else {
                projectVM.addData(name: projectName, desc: projectDesc)
            }
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Project Name (Required)"
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Project Desc (Optional)"
        }

        let cancel = UIAlertAction(title: "Cancel", style: .destructive){(_) in
            
        }

        //adding into alertview
        alert.addAction(cancel)

        alert.addAction(confirmAction)

        //presenting alertView
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: {

        })
        
        
    }
    
    @State var shouldShowEditBoard = false
    
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
                                ForEach (projectVM.projects) { item in
                                    NavigationLink  {
                                        InsideBoardView(project: item, taskVM: taskVM, projectName: item.name)
                                    } label: {
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 25)
                                                .foregroundColor(.white)
                                                .shadow(radius: 1.5)
                                                .frame(width: 350, height: 150)
                                                .foregroundColor(.black)
                                            VStack {
                                                HStack {
                                                    Text(item.name)
                                                        .font(.system(size: 15, weight: .bold)).offset(x:5)

                                                    Spacer()
                                                    NavigationLink {
                                                        BoardDetailView(project: item, vm: projectVM, projectName: item.name, projectDesc: item.desc)
                                                    } label: {
                                                        Image(systemName: "square.and.pencil")
                                                            .font(.system(size: 20))
                                                    }
                                                }
                                                
                                                Text(item.desc)
                                                    .frame(width: 320, height: 80, alignment: .topLeading)
                                                    .multilineTextAlignment(.leading)
                                                
                                            }
                                            .padding()
                                        }
                                        .padding()
                                        
                                    }


                                }
                                
                                .frame(height: 160)
                            }
                        }
                    }
                } else {
                    NetworkConnection()
                }
                
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
        BoardView(projectVM: ProjectViewModel(), taskVM: TaskViewModel())
    }
}

