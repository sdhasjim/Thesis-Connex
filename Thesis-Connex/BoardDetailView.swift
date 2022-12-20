//
//  BoardDetailView.swift
//  Thesis-Connex
//
//  Created by Samuel Dennis on 12/12/22.
//

import SwiftUI

struct BoardDetailView: View {
    
    let project: Project?
    
//    init(project: Project?) {
//        self.project = project
//        self.vm = .init(project: project)
//    }
    
    @ObservedObject var vm = ProjectViewModel()
    
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var projectName = ""
    @State var projectDesc = ""
    @State var date = Date()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(" Project Name")
                    TextField("Project Name", text: $projectName)
                        .padding(9)
                        .foregroundColor(.black)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    Text(" Project Description")
                    TextField("Project Description", text: $projectDesc)
                        .padding(9)
                        .foregroundColor(.black)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    Text(" Collaborator")
                    TextField("Test", text: $projectName)
                        .padding(9)
                        .foregroundColor(.black)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    DatePicker(
                        "Due Date",
                         selection: $date,
                         displayedComponents: [.date, .hourAndMinute]
                    )
                    Divider()
                    HStack {
                        Button {
                            vm.deleteData(projectToDelete: project!)
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Delete project")
                                .foregroundColor(.red)
                        }
                        
                        Spacer()
                        
                        Button {
                            print("Finish")
                        } label: {
                            Text("Finish Project")
                                .font(.system(size: 20, weight: .bold))
                        }
                    }


                }.padding()
                
            }
            .navigationTitle("Project Detail").navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button {
                            vm.updateExistingData(projectToUpdate: project!, name: projectName, desc: projectDesc)
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

struct BoardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(vm: ProjectViewModel())
    }
}
