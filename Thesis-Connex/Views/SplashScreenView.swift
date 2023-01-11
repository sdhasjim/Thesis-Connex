//
//  SplashScreenView.swift
//  Thesis-Connex
//
//  Created by Jason Lauwrin on 11/01/23.
//

import SwiftUI

struct SplashScreenView: View{
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View{
        
        if isActive {
            ContentView()
        }else{
            ZStack{
                Color("yellow_tone").ignoresSafeArea()
                VStack{
                    VStack{
                        Image("logo")
                            .font(.system(size: 150))
                        Text("Connexsi")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.black)
                    }
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear{
                        withAnimation(.easeIn(duration: 1.5)){
                            self.size = 1.5
                            self.opacity = 1.0
                        }
                    }
                }
                .onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

struct SpashScreenView_Previews: PreviewProvider{
    static var previews: some View{
        SplashScreenView()
    }
}
