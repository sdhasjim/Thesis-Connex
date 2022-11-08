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
                            Text("Todo")
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
                }.offset(x: 20)
            }
            }
        }

    var body: some View {
        ZStack{
            Color("yellow_tone").ignoresSafeArea()
            VStack{
//                Picker("choose", selection: $selectedSide){
//
//                ForEach(kanbanChoices.allCases, id: \.self){
//                    Text($0.rawValue)
//                    }
//                }.pickerStyle(SegmentedPickerStyle())
//                    .frame(width: 320)
//                    .offset(y: 20)
                
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
                        
                        if value.translation.width > 20{
                            print("left")
                            self.changeView(left: false)
                        }
                        if -value.translation.width > 20{
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
            if self.index != 0{
                self.index -= 1
            }
        }
        
        if self.index == 1{
            self.offset = 0
        }else if self.index == 2{
            self.offset = -self.width
        }else{
            self.offset = -self.width-self.width
        }
    }
}

//enum kanbanChoices: String, CaseIterable{
//    case todo = "To Do"
//    case progress = "Progress"
//    case done = "Done"
//}
//
//struct ChoosenBoardView: View{
//    var selectedSide: kanbanChoices
//
//    var body: some View{
//        switch selectedSide{
//            case .todo:
//                TodoView()
//
//            case .progress:
//                ProgressingView()
//
//            case .done:
//                DoneView()
//        }
//    }
//}

struct TodoView: View{
    
    var body: some View{
        ScrollView(){
            VStack{
                Text("asu koeaaaaaaagklagbabrjlbalrbglabgljbalgrbgljablrgbalgrajgagalgrbjagbrjlgalbrgaj;bkgkjabrgkjabjkbgkajbglabrgkbalkgrbakljbgrjkabgjkabgkjbakjbgjkabgjklabrgkjlbakjlbgjkabgjkabjrkgbkajlbgjkabgkjrbakjgkabgjklabrgjkbajkgbjkabgjkabgjkabgjkbajgkbalgbaasu koeaaaaaaagklagbabrjlbalrbglabgljbalgrbgljablrgbalgrajgagalgrbjagbrjlgalbrgaj;bkgkjabrgkjabjkbgkajbglabrgkbalkgrbakljbgrjkabgjkabgkjbakjbgjkabgjklabrgkjlbakjlbgjkabgjkabjrkgbkajlbgjkabgkjrbakjgkabgjklabrgjkbajkgbjkabgjkabgjkabgjkbajgkbalgbaasu koeaaaaaaagklagbabrjlbalrbglabgljbalgrbgljablrgbalgrajgagalgrbjagbrjlgalbrgaj;bkgkjabrgkjabjkbgkajbglabrgkbalkgrbakljbgrjkabgjkabgkjbakjbgjkabgjklabrgkjlbakjlbgjkabgjkabjrkgbkajlbgjkabgkjrbakjgkabgjklabrgjkbajkgbjkabgjkabgjkabgjkbajgkbalgbaasu koeaaaaaaagklagbabrjlbalrbglabgljbalgrbgljablrgbalgrajgagalgrbjagbrjlgalbrgaj;bkgkjabrgkjabjkbgkajbglabrgkbalkgrbakljbgrjkabgjkabgkjbakjbgjkabgjklabrgkjlbakjlbgjkabgjkabjrkgbkajlbgjkabgkjrbakjgkabgjklabrgjkbajkgbjkabgjkabgjkabgjkbajgkbalgbaasu koeaaaaaaagklagbabrjlbalrbglabgljbalgrbgljablrgbalgrajgagalgrbjagbrjlgalbrgaj;bkgkjabrgkjabjkbgkajbglabrgkbalkgrbakljbgrjkabgjkabgkjbakjbgjkabgjklabrgkjlbakjlbgjkabgjkabjrkgbkajlbgjkabgkjrbakjgkabgjklabrgjkbajkgbjkabgjkabgjkabgjkbajgkbalgba").multilineTextAlignment(.leading).frame(alignment: .leading)
            }
        }
    }
}

struct ProgressingView: View{
    
    var body: some View{
        ScrollView(){
            VStack{
                Text("asevenya")
            }
        }
    }
}

struct DoneView: View{
    
    var body: some View{
        ScrollView(){
            VStack{
                Text("aidis ababa")
            }
        }
    }
}


struct InsideBoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
    }
}

