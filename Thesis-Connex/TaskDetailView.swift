//
//  TaskDetailView.swift
//  Thesis-Connex
//
//  Created by Samuel Dennis on 12/12/22.
//

import SwiftUI

struct TaskDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var projectName = ""
    @State var date = Date()
    @State var selectedPriority = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(" Task Name")
                    TextField("Task Name", text: $projectName)
                        .padding(9)
                        .foregroundColor(.black)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    Text(" Task Description")
                    TextField("Task Description (optional)", text: $projectName, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                        .padding(9)
                        .foregroundColor(.black)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    Text(" Task Priority")
                    Picker("Test", selection: $selectedPriority) {
                        Text("Red").tag(0)
                        Text("Green").tag(1)
                        Text("Blue").tag(2)
                    }.pickerStyle(.segmented)
                    TextField("Assignee", text: $projectName)
                        .padding(9)
                        .foregroundColor(.black)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    DatePicker(
                        " Due Date",
                         selection: $date,
                         displayedComponents: [.date, .hourAndMinute]
                    )
                    Text(" Attachment")
                    Text(" Comment")

                }.padding()
                
            }
            .navigationTitle("Task Detail").navigationBarTitleDisplayMode(.inline)
//                .toolbar {
//                    ToolbarItemGroup(placement: .navigationBarLeading) {
//                        Button {
//                            presentationMode.wrappedValue.dismiss()
//                        } label: {
//                            Text("Cancel")
//                                .foregroundColor(.blue)
//                        }
//                    }
//                    ToolbarItemGroup(placement: .navigationBarTrailing) {
//                        Button {
//                            presentationMode.wrappedValue.dismiss()
//                        } label: {
//                            Text("Save")
//                                .foregroundColor(.black)
//                        }
//                    }
//                }
        }
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailView()
    }
}
