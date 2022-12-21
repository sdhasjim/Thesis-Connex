//
//  TaskDetailView.swift
//  Thesis-Connex
//
//  Created by Samuel Dennis on 12/12/22.
//

import SwiftUI

struct TaskDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    let task: Task?
    @ObservedObject var vm: TaskViewModel
    @State var taskName = ""
    
    @State var taskDesc = ""
    @State var taskAssignee = ""
    
    @State var dateSelected = Date()
    @State var dueDate = ""
    @State var selectedPriority = 0
    @State var taskPriority = ""
    
    var body: some View {
        NavigationView {
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
                    TextField("Assignee", text: $taskAssignee)
                        .padding(9)
                        .foregroundColor(.black)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    DatePicker(
                        " Due Date",
                         selection: $dateSelected,
                         displayedComponents: [.date, .hourAndMinute]
                    )

                    Text(" Comment")
                    Button {
                        vm.deleteData(taskToDelete: task!)
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Delete Task")
                            .foregroundColor(.red)
                    }
                    



                }.padding()
                
            }
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
                            vm.updateExistingData(taskToUpdate: task!, name: taskName, assignee: taskAssignee, desc: taskDesc, priority: taskPriority, dueDate: dueDate)
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Save")
                                .foregroundColor(.black)
                        }
                    }
                }
        }
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(projectVM: ProjectViewModel(), taskVM: TaskViewModel())
    }
}
