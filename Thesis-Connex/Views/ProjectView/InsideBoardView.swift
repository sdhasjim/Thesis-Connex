//
//  InsideBoardView.swift
//  Thesis-Connex
//
//  Created by Jason Lauwrin on 08/11/22.
//

import SwiftUI

struct AppBar: View{
    
    @Binding var index: Int
    @Binding var offset: CGFloat
    var width = UIScreen.main.bounds.width
    
    var body: some View{
        VStack(alignment: .leading, content: {
            HStack{
                Button(action: {
                    self.index = 1
                    self.offset = 0
                }) {
                    VStack(spacing: 8){
                        HStack(spacing: 12){
                            Text("To Do")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(self.index == 1 ? Color("brown_tone") : Color("brown_tone").opacity(0.7))
                        }
                        Capsule()
                            .fill(self.index == 1 ? Color("brown_tone") : .clear.opacity(0.7))
                            .frame(height: 4)
                    }
                }
                
                Button(action: {
                    self.index = 2
                    self.offset = -self.width
                }) {
                    VStack(spacing: 8){
                        HStack(spacing: 12){
                            Text("Progressing")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(self.index == 2 ? Color("brown_tone") : Color("brown_tone").opacity(0.7))
                        }
                        Capsule()
                            .fill(self.index == 2 ? Color("brown_tone") : .clear.opacity(0.7))
                            .frame(height: 4)
                    }
                }
                
                Button(action: {
                    self.index = 3
                    self.offset = -self.width-self.width
                }) {
                    VStack(spacing: 8){
                        HStack(spacing: 12){
                            Text("Done")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(self.index == 3 ? Color("brown_tone") : Color("brown_tone").opacity(0.7))
                        }
                        Capsule()
                            .fill(self.index == 3 ? Color("brown_tone") : .clear.opacity(0.7))
                            .frame(height: 4)
                    }
                }
            }
        })
        .padding(.top, (UIApplication.shared.windows.first?.safeAreaInsets.top)! + 15)
        .padding(.horizontal)
        .padding(.bottom, 10)
        .background(Color("yellow_tone"))
        .background(Color.white)
    }
}

struct InsideBoardView: View {
    
    let project: Project?
//    let task: Task?
    
    @ObservedObject var taskVM: TaskViewModel
    
    @State var projectName = ""
    @State var projectDesc = ""
    
    
    @State var selectedTab = "profile"
    @State var index = 1
    @State var offset: CGFloat = 0
    @State var taskName = ""
    var width = UIScreen.main.bounds.width
//    @State private var selectedSide: kanbanChoices = .done
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var insideBoardViewNavbar : some View { Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }){
            
            VStack{
                HStack{
                    Image(systemName: "chevron.left")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 25, height: 25)
                        .background(Color("brown_tone"))
                        .clipShape(Circle())
                        .frame(alignment: .topLeading)
                    
                    Text("  \(project!.name)")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(Color("brown_tone"))
                        .frame(alignment: .topLeading)
                    
                    Button(action: {
                        newTaskView()
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(Color("brown_tone"))
                            .frame(width: 185, alignment: .trailing)
                    })
                }
            }
            .onAppear(perform: {
                taskVM.getDataFromStatusAndProjectID(projectID: project!.id, status: "todo")
                taskVM.getDataFromStatusAndProjectID(projectID: project!.id, status: "progressing")
                taskVM.getDataFromStatusAndProjectID(projectID: project!.id, status: "done")
            })
//            .onAppear(perform: {
////                taskVM.getDataFromProjectID(projectID: project!.id)
//                taskVM.getDataFromStatusAndProjectID(projectID: project!.id, status: "todo")
////                taskVM.getDataFromStatus(status: "todo")
//            })
        }
        
    }
    
    func newTaskView(){
        let alert = UIAlertController(title: "Create New Task", message: "Let's create your task name", preferredStyle: .alert)
        
        let errorAlert = UIAlertController(title: "Failed to Add New Project", message: "Project Name should be filled", preferredStyle: .alert)
        
        errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            print("Ok tapped")
        }))
        
        
        alert.addTextField{(name) in
            name.isSecureTextEntry = false
            name.placeholder = "Task Name"
        }
        
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
                taskVM.addData(projectID: project!.id, name: projectName)
            }
            taskVM.getDataFromStatusAndProjectID(projectID: project!.id, status: "todo")
            taskVM.getDataFromStatusAndProjectID(projectID: project!.id, status: "progressing")
            taskVM.getDataFromStatusAndProjectID(projectID: project!.id, status: "done")
        }
        
        let cancel = UIAlertAction(title: "cancel", style: .destructive){(_) in
            //same
        }
        
        //adding into alertview
        alert.addAction(cancel)
        
        alert.addAction(confirmAction)
        
        //presenting alertView
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: {
        })
    }

    var body: some View {
        
        ZStack{
            Color("yellow_tone").ignoresSafeArea()
            VStack{
                
                AppBar(index: self.$index, offset: self.$offset).offset(y: -50)
                
                GeometryReader{g in
                    
                    HStack(spacing: 0){
                        
                        TodoView(taskVM: taskVM, projectID: project!.id, task: nil)
                            .frame(width: g.frame(in: .global).width)

                        ProgressingView(taskVM: taskVM, projectID: project!.id, task: nil)
                            .frame(width: g.frame(in: .global).width)

                        DoneView(taskVM: taskVM, projectID: project!.id, task: nil)
                            .frame(width: g.frame(in: .global).width)
                    }
                    .offset(x: self.offset)
                    .highPriorityGesture(DragGesture().onEnded({
                        (value) in
                        
                        if value.translation.width > 10{
                            print("left")
                            self.changeView(left: false)
                        }
                        if -value.translation.width > 10{
                            print("right")
                            self.changeView(left: true)
                        }
                    }))
                }
            }
            .animation(.default)
        }

        .navigationBarTitleDisplayMode(.inline)
        
        //ini headernya
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: insideBoardViewNavbar)
        
        //make navbar color to white
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(
            Color("yellow_tone"),
            for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .preferredColorScheme(.light)
    }
    
    func changeView(left : Bool){
        if left{
            if self.index != 3{
                self.index += 1
            }
        }else{
            if self.index != 1{
                self.index -= 1
            }
        }
        
        if self.index == 1{
            self.offset = 0
        }else if self.index == 2{
            self.offset = -self.width
        }else{
            self.offset = (-self.width-self.width)
        }
    }
}

struct TodoView: View{
    
    @ObservedObject var taskVM: TaskViewModel
    
    let projectID: String
    let task: Task?
    
    @State private var showModel = false
    @State var customAlert = false
    @State var HUD = false
    @State var projectName = ""
    var body: some View{

        ZStack{
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.white)
                .shadow(radius: 1.5)
                .foregroundColor(.black)
            ScrollView(){
                ForEach(taskVM.todoTasks) { item in
                    VStack{
                        Button(action: {
                            editTaskView(taskToEdit: item)
                        }, label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundColor(Color("red_tone"))
                                    .shadow(radius: 1.5)
                                VStack{
                                    HStack{
                                        Text(item.name)
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                        NavigationLink {
                                            TaskDetailView(task: item, vm: taskVM, taskName: item.name, taskDesc: item.desc, taskAssignee: item.assignee, taskPriority: item.priority)
                                        } label: {
                                            Image(systemName: "square.and.pencil")
                                                .font(.system(size: 20))
                                                .foregroundColor(.white)
                                        }
                                    }
                                }.frame(width: 280, height: 50, alignment: .topLeading)
                                
                                VStack{
                                    Text("Assigne: \(item.assignee)")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.white)
                                }.frame(width: 280, height: 50, alignment: .bottomLeading)
                            }.frame(width: 300, height: 80)
                        })
                    }
                }

            }.frame(width: 320, height: 520)
        }.frame(width: 340, height: 570).offset(y: -40)
//            .onAppear(perform: {
//                taskVM.getDataFromStatusAndProjectID(projectID: projectID, status: "todo")
//            })

    }
    func editTaskView(taskToEdit: Task?){
        
        let alert = UIAlertController(title: "Task", message: "Edit your task status", preferredStyle: .alert)
        
        let todo = UIAlertAction(title: "To Do", style: .default){(_) in
            taskVM.updateExistingDataStatus(taskToUpdate: taskToEdit!, status: "todo")
            taskVM.getDataFromStatusAndProjectID(projectID: projectID, status: "todo")
            taskVM.getDataFromStatusAndProjectID(projectID: projectID, status: "progressing")
            taskVM.getDataFromStatusAndProjectID(projectID: projectID, status: "done")
            print("TODO")
        }
        
        let progressing = UIAlertAction(title: "Progressing", style: .default){(_) in
            taskVM.updateExistingDataStatus(taskToUpdate: taskToEdit!, status: "progressing")
            taskVM.getDataFromStatusAndProjectID(projectID: projectID, status: "todo")
            taskVM.getDataFromStatusAndProjectID(projectID: projectID, status: "progressing")
            taskVM.getDataFromStatusAndProjectID(projectID: projectID, status: "done")
            print("PROGRESSING")
        }
        
        let done = UIAlertAction(title: "Done", style: .default){(_) in
            taskVM.updateExistingDataStatus(taskToUpdate: taskToEdit!, status: "done")
            taskVM.getDataFromStatusAndProjectID(projectID: projectID, status: "todo")
            taskVM.getDataFromStatusAndProjectID(projectID: projectID, status: "progressing")
            taskVM.getDataFromStatusAndProjectID(projectID: projectID, status: "done")
            print("DONE")
        }
        
        alert.addAction(todo)
        alert.addAction(progressing)
        alert.addAction(done)
        
        //presenting alertView
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: {
            //do your own
        })
//        taskVM
    }
    
}

struct ProgressingView: View{
    
    @ObservedObject var taskVM: TaskViewModel
    
    let projectID: String
    let task: Task?
    
    @State private var showModel = false
    @State var customAlert = false
    @State var HUD = false
    @State var projectName = ""
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.white)
                .shadow(radius: 1.5)
                .foregroundColor(.black)
            ScrollView(){
                ForEach(taskVM.progressingTasks) { item in
                    VStack{
                        Button(action: {
                            editTaskView(taskToEdit: item)
                        }, label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundColor(Color("progressing_tone"))
                                    .shadow(radius: 1.5)
                                VStack{
                                    HStack{
                                        Text(item.name)
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                        NavigationLink {
                                            TaskDetailView(task: item, vm: taskVM, taskName: item.name, taskDesc: item.desc, taskAssignee: item.assignee, taskPriority: item.priority)
                                        } label: {
                                            Image(systemName: "square.and.pencil")
                                                .font(.system(size: 20))
                                                .foregroundColor(.white)
                                        }
                                    }
                                }.frame(width: 280, height: 50, alignment: .topLeading)
                                
                                VStack{
                                    Text("Assigne: \(item.assignee)")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.white)
                                }.frame(width: 280, height: 50, alignment: .bottomLeading)
                            }.frame(width: 300, height: 80)
                        })
                    }
                }

            }.frame(width: 320, height: 520)
        }.frame(width: 340, height: 570).offset(y: -40)
//            .onAppear(perform: {
//                taskVM.getDataFromStatusAndProjectID(projectID: projectID, status: "todo")
//                taskVM.getDataFromStatusAndProjectID(projectID: projectID, status: "progressing")
//                taskVM.getDataFromStatusAndProjectID(projectID: projectID, status: "done")
//            })
    }
    func editTaskView(taskToEdit: Task?){
        let alert = UIAlertController(title: "Task", message: "Edit your task status", preferredStyle: .alert)
        
        let todo = UIAlertAction(title: "To Do", style: .default){(_) in
            taskVM.updateExistingDataStatus(taskToUpdate: taskToEdit!, status: "todo")
            taskVM.getDataFromStatusAndProjectID(projectID: projectID, status: "todo")
            taskVM.getDataFromStatusAndProjectID(projectID: projectID, status: "progressing")
            taskVM.getDataFromStatusAndProjectID(projectID: projectID, status: "done")
            print("TODO")
        }
        
        let progressing = UIAlertAction(title: "Progressing", style: .default){(_) in
            taskVM.updateExistingDataStatus(taskToUpdate: taskToEdit!, status: "progressing")
            taskVM.getDataFromStatusAndProjectID(projectID: projectID, status: "todo")
            taskVM.getDataFromStatusAndProjectID(projectID: projectID, status: "progressing")
            taskVM.getDataFromStatusAndProjectID(projectID: projectID, status: "done")
            print("PROGRESSING")
        }
        
        let done = UIAlertAction(title: "Done", style: .default){(_) in
            taskVM.updateExistingDataStatus(taskToUpdate: taskToEdit!, status: "done")
            taskVM.getDataFromStatusAndProjectID(projectID: projectID, status: "todo")
            taskVM.getDataFromStatusAndProjectID(projectID: projectID, status: "progressing")
            taskVM.getDataFromStatusAndProjectID(projectID: projectID, status: "done")
            print("DONE")
        }
        
        alert.addAction(todo)
        alert.addAction(progressing)
        alert.addAction(done)
        
        //presenting alertView
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: {
            //do your own
        })
    }
}

struct DoneView: View{
    
    @ObservedObject var taskVM: TaskViewModel
    
    let projectID: String
    let task: Task?
    
    @State private var showModel = false
    @State var customAlert = false
    @State var HUD = false
    @State var projectName = ""
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.white)
                .shadow(radius: 1.5)
                .foregroundColor(.black)
            ScrollView(){
                ForEach(taskVM.doneTasks) { item in
                    VStack{
                        Button(action: {
                            editTaskView(taskToEdit: item)
                        }, label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundColor(Color("green_tone"))
                                    .shadow(radius: 1.5)
                                VStack{
                                    HStack{
                                        Text(item.name)
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                        NavigationLink {
                                            TaskDetailView(task: item, vm: taskVM, taskName: item.name, taskDesc: item.desc, taskAssignee: item.assignee, taskPriority: item.priority)
                                        } label: {
                                            Image(systemName: "square.and.pencil")
                                                .font(.system(size: 20))
                                                .foregroundColor(.white)
                                        }
                                    }
                                }.frame(width: 280, height: 50, alignment: .topLeading)
                                
                                VStack{
                                    Text("Assigne: \(item.assignee)")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.white)
                                }.frame(width: 280, height: 50, alignment: .bottomLeading)
                            }.frame(width: 300, height: 80)
                        })
                    }
                }
            }.frame(width: 320, height: 520)
        }.frame(width: 340, height: 570).offset(y: -40)
//            .onAppear(perform: {
//                taskVM.getDataFromStatusAndProjectID(projectID: projectID, status: "done")
//            })
    }
    func editTaskView(taskToEdit: Task?){
        let alert = UIAlertController(title: "Task", message: "Edit your task status", preferredStyle: .alert)
        
        let todo = UIAlertAction(title: "To Do", style: .default){(_) in
            taskVM.updateExistingDataStatus(taskToUpdate: taskToEdit!, status: "todo")
            taskVM.getDataFromStatusAndProjectID(projectID: projectID, status: "todo")
            taskVM.getDataFromStatusAndProjectID(projectID: projectID, status: "progressing")
            taskVM.getDataFromStatusAndProjectID(projectID: projectID, status: "done")
            print("TODO")
        }
        
        let progressing = UIAlertAction(title: "Progressing", style: .default){(_) in
            taskVM.updateExistingDataStatus(taskToUpdate: taskToEdit!, status: "progressing")
            taskVM.getDataFromStatusAndProjectID(projectID: projectID, status: "todo")
            taskVM.getDataFromStatusAndProjectID(projectID: projectID, status: "progressing")
            taskVM.getDataFromStatusAndProjectID(projectID: projectID, status: "done")
            print("PROGRESSING")
        }
        
        let done = UIAlertAction(title: "Done", style: .default){(_) in
            taskVM.updateExistingDataStatus(taskToUpdate: taskToEdit!, status: "done")
            taskVM.getDataFromStatusAndProjectID(projectID: projectID, status: "todo")
            taskVM.getDataFromStatusAndProjectID(projectID: projectID, status: "progressing")
            taskVM.getDataFromStatusAndProjectID(projectID: projectID, status: "done")
            print("DONE")
        }
        
        //adding into alertview
        alert.addAction(todo)
        alert.addAction(progressing)
        alert.addAction(done)
        
        //presenting alertView
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: {
            //do your own
        })
    }
}


struct InsideBoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(projectVM: ProjectViewModel(), taskVM: TaskViewModel())
    }
}

