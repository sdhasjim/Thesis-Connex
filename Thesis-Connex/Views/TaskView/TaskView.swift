//
//  TaskView.swift
//  Thesis-Connex
//
//  Created by Jason Lauwrin on 02/11/22.
//

import SwiftUI

struct TaskView: View {
    @State var selectedTab = "task"
    
    @ObservedObject var taskVM: TaskViewModel
    
    var body: some View {
        ZStack{
            Color("yellow_tone").ignoresSafeArea()
            ScrollView(){
                VStack{
                    Text("Your Task").font(.system(size: 28, weight: .bold))
                        .frame(width: 330, alignment: .leading)
                        .foregroundColor(Color("brown_tone"))
                    
                    ForEach(taskVM.assignedTasks) { item in
                        Button(action: {
                            editTaskView()
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
                                    }
                                }.frame(width: 300, height: 50, alignment: .topLeading)
                                
                                VStack{
                                    Text(item.desc)
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.white)
                                }.frame(width: 300, height: 50, alignment: .bottomLeading)
                            }.frame(width: 340, height: 80)
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

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView(taskVM: TaskViewModel())
    }
}
