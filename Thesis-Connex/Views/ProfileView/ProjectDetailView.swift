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
            .onAppear(perform: {
                taskVM.getDataFromProjectID(projectID: project!.id)
            })
        }
        
    }
    
    var body: some View {
        ZStack{
            Color("yellow_tone").ignoresSafeArea()
            ScrollView(){
                VStack{
                    Text("Overal Score")
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
                            Text("Start")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(Color("brown_tone"))
                                .frame(width: 360, height: 15, alignment: .leading)
                                .offset(x: 10)
                            ScrollView(.horizontal){
                                HStack{
                                    Spacer()
                                    ForEach(scoreVM.scores) { item in
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 25)
                                                .foregroundColor(.white)
                                                .shadow(radius: 1.5)
                                                .frame(width: 130, height: 100)
                                            VStack{
                                                Text(item.userStart)
                                                .font(.system(size: 12, weight: .regular)).foregroundColor(.black)
                                            }.frame(width: 120, height: 80)
                                        }.offset(x: 20)
                                    }
                                    Spacer()
                                }.frame(height: 110)
                            }.frame(maxWidth: .infinity)
                        }
                        
                        VStack{
                            Text("Stop")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(Color("brown_tone"))
                                .frame(width: 360, height: 15, alignment: .leading)
                                .offset(x: 10)
                            ScrollView(.horizontal){
                                HStack{
                                    Spacer()
                                    
                                    ForEach(scoreVM.scores) { item in
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 25)
                                                .foregroundColor(.white)
                                                .shadow(radius: 1.5)
                                                .frame(width: 130, height: 100)
                                            VStack{
                                                Text(item.userStop)
                                                .font(.system(size: 12, weight: .regular)).foregroundColor(.black)
                                            }.frame(width: 120, height: 80)
                                        }
                                    }
                                    
                                    Spacer()
                                }.frame(height: 110)
                            }
                            .frame(width: 360)
                        }
                        
                        VStack{
                            Text("Continue")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(Color("brown_tone"))
                                .frame(width: 360, height: 15, alignment: .leading)
                                .offset(x: 10)
                            ScrollView(.horizontal){
                                HStack{
                                    Spacer()
                                    ForEach(scoreVM.scores) { item in
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 25)
                                                .foregroundColor(.white)
                                                .shadow(radius: 1.5)
                                                .frame(width: 130, height: 100)
                                            VStack{
                                                Text(item.userContinue)
                                                .font(.system(size: 12, weight: .regular)).foregroundColor(.black)
                                            }.frame(width: 120, height: 80)
                                        }.offset(x: 20)
                                    }
                                    Spacer()
                                }.frame(height: 110)
                            }.frame(maxWidth: .infinity)
                        }
                    }.offset(y:40)
                }
//                .onAppear {
//                    scoreVM.scoreCalculation()
//                }
                Text("").frame(height: 80)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scrollIndicators(.hidden)
        }
        .onAppear(perform: {
            scoreVM.getDataFromProjectID(projectID: project?.id ?? "")
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

struct ProjectDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(projectVM: ProjectViewModel(), taskVM: TaskViewModel(), profileVM: ProfileViewModel(), scoreVM: ScoreViewModel())
    }
}

