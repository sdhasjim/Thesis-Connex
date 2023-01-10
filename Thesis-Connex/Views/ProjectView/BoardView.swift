//
//  BoardView.swift
//  Thesis-Connex
//
//  Created by Jason Lauwrin on 01/11/22.
//

import SwiftUI


struct NetworkConnection: View {
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
    // project that is unfinished only to show in board view
    var filteredProject: [Project] {
        // find projects that is unfinished
        var unfinishedProjects = projectVM.projects.filter {
            $0.status == "unfinished"
        }
        // if no search, return immediately
        guard searchText.isEmpty == false
        else {
            return unfinishedProjects
        }
        // do additional filter based on search
        var filtered: Set<Project> = []
        if searchText.isEmpty == false
        {
            // filter dari judul
            let a = unfinishedProjects.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
            // filter dari deskripsi
            let b = unfinishedProjects.filter {
                $0.desc.localizedCaseInsensitiveContains(searchText)
            }
            [a, b].forEach { $0.forEach { filtered.insert($0) } }
        }
        return Array(filtered)
    }
    
    @State private var searchText = ""
    @State private var projectPendingReview: Project?
    
    @State var selectedTab = "board"
    @ObservedObject var monitor = NetworkMonitorConnex()
    @State private var showAlertSheet = false
    @State var customAlert = false
    @State var HUD = false
    @State var projectName = ""
    @State var projectDesc = ""
    
    @ObservedObject var projectVM: ProjectViewModel
    @ObservedObject var taskVM: TaskViewModel
    @ObservedObject var profileVM: ProfileViewModel
    @ObservedObject var scoreVM: ScoreViewModel
    
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
            }
            if let textField = alert.textFields?.last, let text = textField.text {
                projectDesc = text
            }
            
            if projectName == "" {
                UIApplication.shared.windows.first?.rootViewController?.present(errorAlert, animated: true, completion: {

                })
            }
            else {
                projectVM.addData(name: projectName, desc: projectDesc, owner: FirebaseManager.shared.auth.currentUser?.email ?? "")
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
    
    var body: some View {
        
        NavigationView{
            ZStack(alignment: .bottom, content: {
                Color("yellow_tone").ignoresSafeArea()
                
                if monitor.isConnected{
                    VStack{
                        ScrollView(){
                            VStack {
                                ForEach (filteredProject)
                                { item in
                                    NavigationLink  {
                                        InsideBoardView(project: item, collaborator: item.collaborator, taskVM: taskVM, profileVM: profileVM, projectName: item.name)
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
                                                        .font(.system(size: 15, weight: .bold))
                                                        .frame(width: 290, alignment: .leading)

                                                    NavigationLink {
                                                        BoardDetailView(project: item, vm: projectVM, profileVM: profileVM, scoreVM: scoreVM, projectName: item.name, projectDesc: item.desc, collaborator: item.collaborator)
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
                                }.frame(height: 160)
                            }
                        }
                        .searchable(text: $searchText)
                        .navigationBarBackButtonHidden(true)
                        .navigationBarItems(leading: mainNavBar)
                    }
                } else {
                    NetworkConnection()
                }
                
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear(perform: {
                projectVM.startupGetDataFromUser()
            })
        }
        .navigationViewStyle(.stack)
        
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(
            Color("yellow_tone"),
            for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .preferredColorScheme(.light)
        .toolbar(.visible, for: .tabBar)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .alert(isPresented: $projectVM.isQueueForProjectReviewPresented) {
            return Alert(
                title: Text("Yay Project Finished!"),
                message: Text("Please take your time to review your fellow collaborator for project: \(projectVM.queueForProjectReview[0].name)"),
                dismissButton: .destructive(Text("ok")) {
                    projectPendingReview = projectVM.queueForProjectReview.removeFirst()
                    isShowScoringDetail = true
                }
            )}
        .fullScreenCover(isPresented: $isShowScoringDetail) {
            NavigationView {
                ScoringView(project: projectPendingReview!, profileVM: profileVM, scoreVM: scoreVM, projectVM: projectVM)
            }
                
            }
    }
    
    @State var isShowScoringDetail = false
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(projectVM: ProjectViewModel(), taskVM: TaskViewModel(), profileVM: ProfileViewModel(), scoreVM: ScoreViewModel())
    }
}

