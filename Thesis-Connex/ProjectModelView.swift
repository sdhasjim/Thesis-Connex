//
//  ProjectModelView.swift
//  Thesis-Connex
//
//  Created by Jason Lauwrin on 05/12/22.
//

import SwiftUI

struct ProjectModelView: View{
    @Binding var isShowing: Bool
    @State private var curHeight: CGFloat = 400
    @State var projectName = ""
    @State var projectDesc = ""
    @State var isTapped = false
    
    let minHeight: CGFloat = 400
    let maxHeight: CGFloat = 400
    
    var body: some View{
        if isShowing{
            ZStack(alignment: .bottom){
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing = false
                    }
                mainView
                    .transition(.move(edge: .bottom))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()
            .animation(.easeInOut)
        }
    }
    var mainView: some View{
        VStack{
            
            ZStack{
                Capsule()
                    .frame(width: 40, height: 6)
            }
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.00001))
            
            ZStack{
                VStack{
                    Text("Project Name")
                        .font(.system(size: 20, weight: .regular))
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 10)
                    
                    TextField("", text: $projectName){(status) in
                        //it will fire when textfield is clicked
                        if status{
                            withAnimation(.easeIn){
                                isTapped = true
                            }
                        }
                    } onCommit: {
                        //it will fire when return button is pressed
                        withAnimation(.easeOut){
                            isTapped = false
                        }
                    }
                    .padding(.leading, isTapped ? 15 : 15)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(.gray)
                    )
                    .frame(width: 340, height: 0)
                    
                    
                    VStack{
                        Text("Project Description")
                            .font(.system(size: 20, weight: .regular))
                            .multilineTextAlignment(.leading)
                            .padding(.bottom, 10)
                        
                        TextField("", text: $projectDesc){(status) in
                            //it will fire when textfield is clicked
                            if status{
                                withAnimation(.easeIn){
                                    isTapped = true
                                }
                            }
                        } onCommit: {
                            //it will fire when return button is pressed
                            withAnimation(.easeOut){
                                isTapped = false
                            }
                        }
                        .padding(.leading, isTapped ? 15 : 15)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(.gray)
                        )
                        .frame(width: 340, height: 0)
                    }.offset(y:0)
                }
                .frame(height: 300, alignment: .topLeading)
                .padding(.horizontal,30)
                .offset(y: 0)
            }
            .frame(maxHeight: .infinity)
            .padding(.bottom, 35)
        }
        .frame(height: curHeight)
        .frame(maxWidth: .infinity)
        .background(
            ZStack{
                RoundedRectangle(cornerRadius: 80)
                Rectangle().frame(height: curHeight / 2)
            }
                .foregroundColor(.white))
    }
}

struct ProjectModelView_Previews: PreviewProvider{
    static var previews: some View{
        BoardView()
    }
}
