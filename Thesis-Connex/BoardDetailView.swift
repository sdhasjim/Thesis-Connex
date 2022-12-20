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
    
    @ObservedObject var vm: ProjectViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var projectName = ""
    @State var projectDesc = ""
    @State var date = Date()
    
    var boardDetailNavBar : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
    }){
        
        HStack{
            Image(systemName: "chevron.left")
                .font(.system(size: 8, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 20, height: 20)
                .background(Color("brown_tone"))
                .clipShape(Circle())
                .frame(alignment: .topLeading)
            
            Text("  Back")
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(Color("brown_tone"))
                .frame(width: 280, alignment: .topLeading)
            
            Button {
                vm.updateExistingData(projectToUpdate: project!, name: projectName, desc: projectDesc)
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Save")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(Color("brown_tone"))
            }
            .frame(alignment: .trailing)
        }
        
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack{
                Color("yellow_tone").ignoresSafeArea()
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
                        VStack {
                            Button {
                                print("Finish")
                            } label: {
                                
                                ZStack{
                                    RoundedRectangle(cornerRadius: 25)
                                        .foregroundColor(Color("green_tone"))
                                        .shadow(radius: 1.5)
                                        .frame(width: 200, height: 40)
                                    VStack {
                                        Text("Finish Project")
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            
                            Spacer()
                            
                            Button {
                                vm.deleteData(projectToDelete: project!)
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 25)
                                        .foregroundColor(Color("red_tone"))
                                        .shadow(radius: 1.5)
                                        .frame(width: 200, height: 40)
                                    VStack {
                                        Text("Delete Project")
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                        }.frame(maxWidth: .infinity, alignment: .center).offset(y:20)


                    }.padding()
                    
                }
            }
        }.navigationBarTitleDisplayMode(.inline)
        
        //ini headernya
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: boardDetailNavBar)
        
        //make navbar color to white
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(
            Color("yellow_tone"),
            for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .preferredColorScheme(.light)
    }

}

struct BoardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(vm: ProjectViewModel())
    }
}
