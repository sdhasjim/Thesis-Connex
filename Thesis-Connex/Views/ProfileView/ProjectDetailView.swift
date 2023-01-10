//
//  ProjectDetailView.swift
//  Thesis-Connex
//
//  Created by Jason Lauwrin on 22/12/22.
//

import SwiftUI

struct ProjectDetailView: View {
    
    let project: Project?
//    let task: Task?
    
    @ObservedObject var taskVM: TaskViewModel
    @ObservedObject var scoreVM: ScoreViewModel
    
    @State var progressValue: Float = 0.0
    @State var projectName = ""
    @State var projectDesc = ""
    @State var selectedTab = "profile"
    @State var index = 1
    @State var offset: CGFloat = 0
    @State var taskName = ""
    @State private var isExpanded1 = false
    @State private var isExpanded2 = false
    @State private var isExpanded3 = false
    @Environment(\.presentationMode) var presentationMode
    
    var projectDetailViewNavbar : some View { Button(action: {
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
                        .offset(x: 10)
                    
                    Text("    \(project!.name)")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(Color("brown_tone"))
                        .frame(width: 290, alignment: .top)
                        .offset(x: -10)
                }
            }
        }
        
    }
    
    var body: some View {
        ZStack{
            Color("yellow_tone").ignoresSafeArea()
            ScrollView(){
                if project!.collaborator.count == 1 && project!.collaborator.contains(FirebaseManager.shared.auth.currentUser?.email ?? "") {
                    // TODO: Create UI if they finish the project alone
                    Text("All Olone!")
                }
                else {
                    VStack {
                        Text("Overall Score")
                            .font(.system(size: 35, weight: .semibold))
                            .foregroundColor(Color("brown_tone"))
                        
                        ProgressBar(progress: $scoreVM.progressValue)
                            .frame(width: 360, height: 200, alignment: .top)
                            .padding(20.0).onAppear(){
                                self.progressValue = scoreVM.progressValue
                            }
                        ZStack{
                            Text("\(scoreVM.finalScore)")
                                .font(.system(size: 60, weight: .semibold))
                                .foregroundColor(Color("brown_tone"))
                                .offset(y: -130)
                                .frame(height: 0)
                        }
                        
                        VStack{
                            
                            VStack{
                                DisclosureGroup(isExpanded: $isExpanded1){
                                    ForEach(scoreVM.scores) { item in
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 25)
                                                .foregroundColor(.white)
                                                .shadow(radius: 1.5)
                                                .frame(width: 340, height: 100)
                                            VStack{
                                                Text(item.userStart)
                                                    .font(.system(size: 12, weight: .semibold)).foregroundColor(Color("brown_tone"))
                                                    .frame(width: 330, height: 80, alignment: .topLeading)
                                                    .offset(y:5)
                                            }.frame(width: 350, height: 80)
                                        }
                                    }.frame(height: 110)
                                    Spacer()
                                } label: {
                                    HStack{
                                        Text("What you need to start")
                                    }.frame(width: 310, alignment: .leading)
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(Color("brown_tone"))
                                }.frame(width: 350, alignment: .top)
                                    .accentColor(Color("brown_tone"))                        }.frame(width: 360)
                            
                            VStack{
                                DisclosureGroup(isExpanded: $isExpanded2){
                                    ForEach(scoreVM.scores) { item in
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 25)
                                                .foregroundColor(.white)
                                                .shadow(radius: 1.5)
                                                .frame(width: 340, height: 100)
                                            VStack{
                                                Text(item.userStop)
                                                    .font(.system(size: 12, weight: .semibold)).foregroundColor(Color("brown_tone"))
                                                    .frame(width: 330, height: 80, alignment: .topLeading)
                                                    .offset(y:5)
                                            }.frame(width: 350, height: 80)
                                        }
                                    }.frame(height: 110)
                                    Spacer()
                                } label: {
                                    HStack{
                                        Text("What you need to stop")
                                    }.frame(width: 310, alignment: .leading)
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(Color("brown_tone"))
                                }.frame(width: 350, alignment: .top)
                                    .accentColor(Color("brown_tone"))
                            }.frame(width: 360)
                            
                            VStack{
                                DisclosureGroup(isExpanded: $isExpanded3){
                                    ForEach(scoreVM.scores) { item in
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 25)
                                                .foregroundColor(.white)
                                                .shadow(radius: 1.5)
                                                .frame(width: 340, height: 100)
                                            VStack{
                                                Text(item.userContinue)
                                                    .font(.system(size: 12, weight: .semibold)).foregroundColor(Color("brown_tone"))
                                                    .frame(width: 330, height: 80, alignment: .topLeading)
                                                    .offset(y:5)
                                            }.frame(width: 350, height: 80)
                                        }
                                    }.frame(height: 110)
                                    Spacer()
                                } label: {
                                    HStack{
                                        Text("What you need to continue")
                                    }.frame(width: 310, alignment: .leading)
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(Color("brown_tone"))
                                }.frame(width: 350, alignment: .top)
                                    .accentColor(Color("brown_tone"))
                            }.frame(width: 360)
                        }.frame(width: 360).frame(maxHeight: .infinity)
                    }
                    Text("").frame(height: 80)
                }

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scrollIndicators(.hidden)
        }
        .onAppear(perform: {
            taskVM.getDataFromProjectID(projectID: project!.id)
            scoreVM.getIncomingDataFromProjectID(projectID: project!.id)
        })
        .navigationBarTitleDisplayMode(.inline)
        
        //ini headernya
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: projectDetailViewNavbar)
        
        //make navbar color to white
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(
            Color("yellow_tone"),
            for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .preferredColorScheme(.light)
    }
    
}

struct ProgressBar: View{
    @Binding var progress: Float
    
    var body: some View{
        ZStack{
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.20)
                .foregroundColor(Color.gray)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 12.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color("brown_tone"))
                .rotationEffect(Angle(degrees: 270))
                .animation(.easeInOut(duration: 2.0))
        }
    }
}

//struct ProjectDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProjectDetailView(project: <#T##Project?#>, taskVM: <#T##TaskViewModel#>, scoreVM: <#T##ScoreViewModel#>)
//    }
//}

