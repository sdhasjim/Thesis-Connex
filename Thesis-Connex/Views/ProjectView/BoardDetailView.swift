//
//  BoardDetailView.swift
//  Thesis-Connex
//
//  Created by Samuel Dennis on 12/12/22.
//

import SwiftUI

struct BoardDetailView: View {
    
    let project: Project?
    
    @ObservedObject var vm: ProjectViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var projectName = ""
    @State var projectDesc = ""
    @State var collaborator = [String]()
    @State var date = Date()
    
    @State var shouldShowNewMessageScreen = false
    
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
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color("brown_tone"))
                .frame(width: 275, alignment: .topLeading)
            
            Button {
                vm.updateExistingData(projectToUpdate: project!, name: projectName, desc: projectDesc, collaborator: collaborator)
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Save")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color("brown_tone"))
            }
            .frame(alignment: .trailing)
        }.offset(x: 5)
        
    }
    }
    
    private var inviteCollaborator: some View {
        Button {
            shouldShowNewMessageScreen.toggle()
        } label: {
            HStack {
                Spacer()
                Text("+ Invite To Project")
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
            InviteCollaborator(didSelectNewUser: { user
                in
                print(user.email)
                //                            self.shouldNavigateToChatLogView.toggle()
                self.profileUser = user
                self.collaborator.append(self.profileUser!.email)
                print(collaborator)
            }, vm: CreateNewMessageViewModel(collaborator: collaborator))
        }
    }
    
    @State var profileUser: ProfileUser?
    
    private var projectProperty: some View {
        VStack {
            NavigationLink {
                ScoringView()
            } label: {
                
                ZStack{
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(Color("green_tone"))
                        .shadow(radius: 1.5)
                        .frame(width: 200, height: 40)
                    VStack {
                        Text("Finish Project")
                            .font(.system(size: 15, weight: .regular))
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
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.white)
                    }
                }
            }
        }.frame(maxWidth: .infinity, alignment: .center).offset(y:20)
    }
    
    var body: some View {
        ZStack{
            Color("yellow_tone").ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Group {
                        Text(" Project Name")
                        TextField("Project Name", text: $projectName)
                            .padding(9)
                            .foregroundColor(.black)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                    Group {
                        Text(" Project Description")
                        TextField("Project Description", text: $projectDesc)
                            .padding(9)
                            .foregroundColor(.black)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                    Text(" Collaborator")
                    VStack(alignment: .leading) {
                        ForEach(collaborator, id:\.self) { c in
                            HStack {
                                Text(c)
                                    .padding()
                                Button {
                                    if let index = self.collaborator.firstIndex(of: c) {
                                        self.collaborator.remove(at: index)
                                    }
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
                    }
                    
                    inviteCollaborator
                    //                    Button {
                    //                        self.collaborator.append(self.projectInvite)
                    //                        self.projectInvite = ""
                    //                        print(collaborator)
                    //                    } label: {
                    //                        Text("Add Item")
                    //                    }
                    
                    //                    DatePicker(
                    //                        "Due Date",
                    //                         selection: $date,
                    //                         displayedComponents: [.date, .hourAndMinute]
                    //                    )
                    Divider()
                    projectProperty
                }.padding()
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
            .preferredColorScheme(.light)
        
            .toolbar(.hidden, for: .tabBar)
    }
}

struct BoardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BoardDetailView(project: Project(id: "AMtXnHmzutlqKvQYHjNe", name: "OOP", desc: "Blablabla", collaborator: ["test", "mantap"]), vm: ProjectViewModel())
    }
}
