//
//  CustomTabBar.swift
//  Thesis-Connex
//
//  Created by Jason Lauwrin on 02/11/22.
//

import SwiftUI

struct CustomTabBar: View{
    @Binding var selectedTab: String
    @State var tabPoints: [CGFloat] = []
    var body: some View{
        HStack(spacing: 0){
           TabBarButton(image: "doc.circle", text: "Board", tabPoints: $tabPoints, selectedTab: $selectedTab)
            
            TabBarButton(image: "hourglass.circle", text: "Task", tabPoints: $tabPoints,selectedTab: $selectedTab)
            
            TabBarButton(image: "bell.circle", text: "Notif", tabPoints: $tabPoints,selectedTab: $selectedTab)
            
            TabBarButton(image: "person.circle", text: "Profile", tabPoints: $tabPoints,selectedTab: $selectedTab)
        }
        .padding()
        .background(
            Color("beidge_tone")
                .clipShape(TabCurve(tabPoint: getCurvePoint() - 20))
        )
        .overlay(
            Circle()
                .fill(Color("brown_tone"))
                .frame(width: 10, height: 10)
                .offset(x: getCurvePoint() - 25)
            ,alignment: .bottomLeading
        )
        .cornerRadius(35)
        .padding(.horizontal)
        .shadow(radius: 1)
        .frame(width: 380, height: 70)
    }
    
    func getCurvePoint()->CGFloat{
        if tabPoints.isEmpty{
            return 10
        }else{
            switch selectedTab {
            case "doc.circle":
                return tabPoints[0]
            case "hourglass.circle":
                return tabPoints[1]
            case "bell.circle":
                return tabPoints[2]
            default:
                return tabPoints[3]
            }
        }
    }
}

struct CustomTabBar_Previews: PreviewProvider{
    static var previews: some View{
        BoardView(vm: ProjectViewModel())
    }
}


struct TabBarButton: View{
    
    var image: String
    var text: String
    @Binding var tabPoints: [CGFloat]
    @Binding var selectedTab: String
    
    var body: some View{
        
        //for getting mid point(curve animation)
        GeometryReader{reader -> AnyView in
            
            let midX = reader.frame(in: .global).midX
            
            DispatchQueue.main.async {
                
                if tabPoints.count <= 4{
                    tabPoints.append(midX)
                }
            }
            
            return AnyView(
                Button(action: {
                    // changing tab
                    withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.5, blendDuration: 0.5)){
                        selectedTab = image
                    }
                }, label: {
                    VStack{
                        Image(systemName: "\(image)\(selectedTab == image ? ".fill" : "")")
                            .font(.system(size: 30, weight: .semibold))
                            .foregroundColor(Color("brown_tone"))
                            .offset(y: selectedTab == image ? -12 : 0)
                        
                        Text("\(text)\(selectedTab == text ? ".fill" : "")")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(Color("brown_tone"))
                            .offset(y: selectedTab == image ? -12 : 0)
                    }
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            )
        }
        .frame(height: 60)
    }
}
