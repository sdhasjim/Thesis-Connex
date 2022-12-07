//
//  InsideBoardView.swift
//  Thesis-Connex
//
//  Created by Jason Lauwrin on 08/11/22.
//

import SwiftUI

struct AppBar: View{
    
    @Binding var index: Int
    @Binding var offset: CGFloat
    var width = UIScreen.main.bounds.width
    
    var body: some View{
        VStack(alignment: .leading, content: {
            HStack{
                Button(action: {
                    self.index = 1
                    self.offset = 0
                }) {
                    VStack(spacing: 8){
                        HStack(spacing: 12){
                            Text("To Do")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(self.index == 1 ? Color("brown_tone") : Color("brown_tone").opacity(0.7))
                        }
                        Capsule()
                            .fill(self.index == 1 ? Color("brown_tone") : .clear.opacity(0.7))
                            .frame(height: 4)
                    }
                }
                
                Button(action: {
                    self.index = 2
                    self.offset = -self.width
                }) {
                    VStack(spacing: 8){
                        HStack(spacing: 12){
                            Text("Progressing")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(self.index == 2 ? Color("brown_tone") : Color("brown_tone").opacity(0.7))
                        }
                        Capsule()
                            .fill(self.index == 2 ? Color("brown_tone") : .clear.opacity(0.7))
                            .frame(height: 4)
                    }
                }
                
                Button(action: {
                    self.index = 3
                    self.offset = -self.width-self.width
                }) {
                    VStack(spacing: 8){
                        HStack(spacing: 12){
                            Text("Done")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(self.index == 3 ? Color("brown_tone") : Color("brown_tone").opacity(0.7))
                        }
                        Capsule()
                            .fill(self.index == 3 ? Color("brown_tone") : .clear.opacity(0.7))
                            .frame(height: 4)
                    }
                }
            }
        })
        .padding(.top, (UIApplication.shared.windows.first?.safeAreaInsets.top)! + 15)
        .padding(.horizontal)
        .padding(.bottom, 10)
        .background(Color("yellow_tone"))
        .background(Color.white)
    }
}

struct InsideBoardView: View {
    @State var selectedTab = "profile"
    @State var index = 1
    @State var offset: CGFloat = 0
    @State var taskName = ""
    var width = UIScreen.main.bounds.width
//    @State private var selectedSide: kanbanChoices = .done
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var insideBoardViewNavbar : some View { Button(action: {
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
                    
                    Text("  Board 1")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color("brown_tone"))
                        .frame(alignment: .topLeading)
                    
                    Button(action: {
                        newTaskView()
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(Color("brown_tone"))
                            .frame(width: 185, alignment: .trailing)
                    })
                }
            }
        }
        
    }
    
    func newTaskView(){
        let alert = UIAlertController(title: "Create New Task", message: "Let's create your task name", preferredStyle: .alert)
        
        
        alert.addTextField{(name) in
            name.isSecureTextEntry = false
            name.placeholder = "Task Name"
        }
        
        let create = UIAlertAction(title: "Create", style: .default){(_) in
            //do yiur own stuff
            
            //retrieving password
            taskName = alert.textFields![0].text!
        }
        
        let cancel = UIAlertAction(title: "cancel", style: .destructive){(_) in
            //same
        }
        
        //adding into alertview
        alert.addAction(cancel)
        
        alert.addAction(create)
        
        //presenting alertView
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: {
            //do your own
        })
    }

    var body: some View {
        ZStack{
            Color("yellow_tone").ignoresSafeArea()
            VStack{
                
                AppBar(index: self.$index, offset: self.$offset).offset(y: -50)
                
                GeometryReader{g in
                    
                    HStack(spacing: 0){
                        
                        TodoView()
                            .frame(width: g.frame(in: .global).width)
                        
                        ProgressingView()
                            .frame(width: g.frame(in: .global).width)
                        
                        DoneView()
                            .frame(width: g.frame(in: .global).width)
                    }
                    .offset(x: self.offset)
                    .highPriorityGesture(DragGesture().onEnded({
                        (value) in
                        
                        if value.translation.width > 10{
                            print("left")
                            self.changeView(left: false)
                        }
                        if -value.translation.width > 10{
                            print("right")
                            self.changeView(left: true)
                        }
                    }))
                }
            }
            .animation(.default)
        }
        .navigationBarTitleDisplayMode(.inline)
        
        //ini headernya
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: insideBoardViewNavbar)
        
        //make navbar color to white
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(
            Color("yellow_tone"),
            for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .preferredColorScheme(.light)
    }
    
    func changeView(left : Bool){
        if left{
            if self.index != 3{
                self.index += 1
            }
        }else{
            if self.index != 1{
                self.index -= 1
            }
        }
        
        if self.index == 1{
            self.offset = 0
        }else if self.index == 2{
            self.offset = -self.width
        }else{
            self.offset = (-self.width-self.width)
        }
    }
}

struct TodoView: View{
    @State private var showModel = false
    @State var customAlert = false
    @State var HUD = false
    @State var projectName = ""
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.white)
                .shadow(radius: 1.5)
                .foregroundColor(.black)
            ScrollView(){
                VStack{
                    Button(action: {
                        editTaskView()
                    }, label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(Color("red_tone"))
                                .shadow(radius: 1.5)
                            VStack{
                                HStack{
                                    Text("Make a prototype")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    NavigationLink(destination: LoginView(), label: {
                                        Image(systemName: "square.and.pencil").font(.system(size: 20)).foregroundColor(.white)
                                    }).offset(x: 90)
                                    
//                                    Button(action: {
//
//                                    }){
//                                        Image(systemName: "square.and.pencil").font(.system(size: 20))
//                                            .foregroundColor(.white)
//                                    }.offset(x: 90)
                                }
                            }.frame(width: 280, height: 50, alignment: .topLeading)
                            
                            VStack{
                                Text("Assigne: Annie")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white)
                            }.frame(width: 280, height: 50, alignment: .bottomLeading)
                        }.frame(width: 300, height: 80)
                    }).frame(width: 320, height: 520, alignment: .top)
                }
            }.frame(width: 320, height: 520)
        }.frame(width: 340, height: 570).offset(y: -40)
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
        
        let delete = UIAlertAction(title: "Delete", style: .destructive){(_) in
            //same
        }
        
        //adding into alertview
        alert.addAction(todo)
        alert.addAction(progressing)
        alert.addAction(done)
        alert.addAction(delete)
        
        //presenting alertView
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: {
            //do your own
        })
    }
    
}

struct ProgressingView: View{
    @State private var showModel = false
    @State var customAlert = false
    @State var HUD = false
    @State var projectName = ""
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.white)
                .shadow(radius: 1.5)
                .foregroundColor(.black)
            ScrollView(){
                VStack{
                    Button(action: {
                        editTaskView()
                    }, label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(Color("progressing_tone"))
                                .shadow(radius: 1.5)
                            VStack{
                                HStack{
                                    Text("Make a prototype")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    NavigationLink(destination: LoginView(), label: {
                                        Image(systemName: "square.and.pencil").font(.system(size: 20)).foregroundColor(.white)
                                    }).offset(x: 90)
                                    
//                                    Button(action: {
//
//                                    }){
//                                        Image(systemName: "square.and.pencil").font(.system(size: 20))
//                                            .foregroundColor(.white)
//                                    }.offset(x: 90)
                                }
                            }.frame(width: 280, height: 50, alignment: .topLeading)
                            
                            VStack{
                                Text("Assigne: Annie")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white)
                            }.frame(width: 280, height: 50, alignment: .bottomLeading)
                        }.frame(width: 300, height: 80)
                    }).frame(width: 320, height: 520, alignment: .top)
                }
            }.frame(width: 320, height: 520)
        }.frame(width: 340, height: 570).offset(y: -40)
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
        
        let delete = UIAlertAction(title: "Delete", style: .destructive){(_) in
            //same
        }
        
        //adding into alertview
        alert.addAction(todo)
        alert.addAction(progressing)
        alert.addAction(done)
        alert.addAction(delete)
        
        //presenting alertView
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: {
            //do your own
        })
    }
}

struct DoneView: View{
    @State private var showModel = false
    @State var customAlert = false
    @State var HUD = false
    @State var projectName = ""
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.white)
                .shadow(radius: 1.5)
                .foregroundColor(.black)
            ScrollView(){
                VStack{
                    Button(action: {
                        editTaskView()
                    }, label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(Color("green_tone"))
                                .shadow(radius: 1.5)
                            VStack{
                                HStack{
                                    Text("Make a prototype")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    NavigationLink(destination: LoginView(), label: {
                                        Image(systemName: "square.and.pencil").font(.system(size: 20)).foregroundColor(.white)
                                    }).offset(x: 90)
                                    
//                                    Button(action: {
//
//                                    }){
//                                        Image(systemName: "square.and.pencil").font(.system(size: 20))
//                                            .foregroundColor(.white)
//                                    }.offset(x: 90)
                                }
                            }.frame(width: 280, height: 50, alignment: .topLeading)
                            
                            VStack{
                                Text("Assigne: Annie")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white)
                            }.frame(width: 280, height: 50, alignment: .bottomLeading)
                        }.frame(width: 300, height: 80)
                    }).frame(width: 320, height: 520, alignment: .top)
                }
            }.frame(width: 320, height: 520)
        }.frame(width: 340, height: 570).offset(y: -40)
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
        
        let delete = UIAlertAction(title: "Delete", style: .destructive){(_) in
            //same
        }
        
        //adding into alertview
        alert.addAction(todo)
        alert.addAction(progressing)
        alert.addAction(done)
        alert.addAction(delete)
        
        //presenting alertView
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: {
            //do your own
        })
    }
}


struct InsideBoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
    }
}

