//
//  TaskDetailView.swift
//  Thesis-Connex
//
//  Created by Samuel Dennis on 12/12/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct TaskDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    let task: Task?
    let collaborator: [String]
    
    @ObservedObject var vm: TaskViewModel
    @ObservedObject var profileVM: ProfileViewModel
    @State var taskName = ""
    
    @State var taskDesc = ""
    @State var taskAssignee = ""
    
    @State var dateSelected = Date()
    @State var dueDate = ""
    @State var selectedPriority = 0
    @State var taskPriority = ""
    
    @State var shouldShowNewMessageScreen = false
    
//    @State var user: User?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(" Task Name")
                TextField("Task Name", text: $taskName)
                    .padding(9)
                    .foregroundColor(.black)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                Text(" Task Description")
                TextField("Task Description (optional)", text: $taskDesc, axis: .vertical)
                    .lineLimit(3, reservesSpace: true)
                    .padding(9)
                    .foregroundColor(.black)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                Text(" Task Priority")
                Picker("Test", selection: $selectedPriority) {
                    Text("Low").tag(0)
                    Text("Medium").tag(1)
                    Text("High").tag(2)
                }.pickerStyle(.segmented)
                Text("Assignee: ")
                
                if profileVM.userAssigned != nil {
                    VStack(alignment: .leading) {
                            HStack {
                                WebImage(url: URL(string: profileVM.userAssigned?.profileImageUrl ?? ""))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipped()
                                    .cornerRadius(50)
                                    .overlay(RoundedRectangle(cornerRadius: 50)
                                        .stroke(Color(.label), lineWidth: 1)
                                    )
                                Text(profileVM.userAssigned?.username ?? "")
                                    .padding()
                                Button {
                                    profileVM.userAssigned = nil
    //                                if let index = self.collaborator.firstIndex(of: c) {
    //                                    self.collaborator.remove(at: index)
    //                                }
                                    print(collaborator)
                                } label: {
                                    Image(systemName: "minus.circle")
                                        .foregroundColor(.red)
                                        .padding()
                                }

                            }
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(20)
                    }
                } else {
                    Button {
                        shouldShowNewMessageScreen.toggle()
                        print(collaborator)
                    } label: {
                        HStack {
                            Spacer()
                            Text("+ Assign Task")
                                .font(.system(size: 16, weight: .bold))
                            Spacer()
                        }
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .background(Color.blue)
                        .cornerRadius(24)
                        .padding(.horizontal)
                        .shadow(radius: 15)
                    }
                    .fullScreenCover(isPresented: $shouldShowNewMessageScreen) {
                        AssignTask(didSelectNewUser: { user in
                            print(user.email)
//                            self.user = user
                            profileVM.userAssigned = user
                        }, vm: AssignTaskViewModel(collaborator: collaborator))
                    }
                }
                
                DatePicker(
                    " Due Date",
                     selection: $dateSelected,
                     displayedComponents: [.date, .hourAndMinute]
                )

//                Text(" Comment")
                Button {
                    vm.deleteData(taskToDelete: task!)
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Delete Task")
                        .foregroundColor(.red)
                }
                



            }.padding()
            
        }
        .onAppear(perform: {
            print(taskAssignee)
            profileVM.fetchAssigneeFromEmail(email: taskAssignee)
            print(profileVM.userAssigned)
        })
        
        .navigationTitle("Task Detail").navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        if selectedPriority == 0 {
                            taskPriority = "Low"
                        } else if selectedPriority == 1 {
                            taskPriority = "Medium"
                        } else {
                            taskPriority = "High"
                        }
                        taskAssignee = profileVM.userAssigned?.email ?? ""
                        vm.updateExistingData(taskToUpdate: task!, name: taskName, assignee: taskAssignee, desc: taskDesc, priority: taskPriority, dueDate: dueDate)
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Save")
                            .foregroundColor(.black)
                    }
                }
            }
        .navigationTitle("Task Detail").navigationBarTitleDisplayMode(.inline)
    }
    
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(projectVM: ProjectViewModel(), taskVM: TaskViewModel(), profileVM: ProfileViewModel(), scoreVM: ScoreViewModel())
    }
}
