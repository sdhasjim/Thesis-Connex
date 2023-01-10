//
//  TaskView.swift
//  Thesis-Connex
//
//  Created by Jason Lauwrin on 02/11/22.
//

import SwiftUI

struct TaskView: View {
//    let task: Task?
    @State private var tabFilter = 1
    @State var selectedTab = "task"
    @ObservedObject var taskVM: TaskViewModel
    @State var isExpanded1 = false
    
    var filteredTask: [Task]{
        if tabFilter == 1 {
            return taskVM.assignedTasks
        } else if (tabFilter == 2){
            return self.taskVM.assignedTasks.filter{$0.status.contains("todo")}
        } else if (tabFilter == 3){
            return self.taskVM.assignedTasks.filter{$0.status.contains("progressing")}
        } else{
            return self.taskVM.assignedTasks.filter{$0.status.contains("done")}
        }
    }
    
    var body: some View {
        ZStack{
            Color("yellow_tone").ignoresSafeArea()
            ScrollView(){
                VStack{
                    Text("Your Task").font(.system(size: 28, weight: .bold))
                        .frame(width: 330, alignment: .leading)
                        .foregroundColor(Color("brown_tone"))
                    
                    HStack{
                        Text("Sort by ")
                        Picker("Option Picker", selection: $tabFilter) {
                            Text("All").tag(1)
                            Text("todo").tag(2)
                            Text("progressing").tag(3)
                            Text("done").tag(4)
                        }.pickerStyle(MenuPickerStyle())
                    }
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color("brown_tone"))
                    .frame(width: 330, alignment: .leading)

                    ForEach(filteredTask) { item in
                        Button(action: {
                            editTaskView()
                        }, label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundColor(Color("\(item.status)"))
                                    .shadow(radius: 1.5)
                                VStack{
                                    VStack{
                                        Text(item.name)
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(.white)
                                            .frame(width: 300, height: 10, alignment: .leading)
                                        Text(item.desc)
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundColor(.white)
                                            .frame(width: 300, height: 40, alignment: .topLeading)
                                        HStack{
                                            Text("Status: ")
                                                .font(.system(size: 12, weight: .semibold))
                                                .foregroundColor(.white)
                                            Text(item.status)
                                                .font(.system(size: 12, weight: .semibold))
                                                .foregroundColor(.white)
                                        }.frame(width: 300, height: 10, alignment: .leading)
                                    }
                                }.frame(width: 300, height: 80, alignment: .topLeading)
                            }.frame(width: 340, height: 100)
                        })
                    }

                }.offset(y: 20)
            }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            taskVM.getData()
        }
    }
    
    func editTaskView(){
        let alert = UIAlertController(title: "Task", message: "Edit your task status", preferredStyle: .alert)
        
        let todo = UIAlertAction(title: "To Do", style: .default){(_) in
            //do yiur own stuff
            
        }
        
        let progressing = UIAlertAction(title: "Progressing", style: .default){(_) in
            //do yiur own stuff
            
        }
        
        let done = UIAlertAction(title: "Done", style: .default){(_) in
            //do yiur own stuff
            
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
