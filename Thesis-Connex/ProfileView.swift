//
//  ProfileView.swift
//  Thesis-Connex
//
//  Created by Jason Lauwrin on 01/11/22.
//

import SwiftUI

struct ProfileView: View {
    @State var selectedTab = "profile"
    var body: some View {
        ZStack{
            Color("yellow_tone").ignoresSafeArea()
            VStack{
                Text("hai hola amigo")
            }
//            CustomTabBar(selectedTab: $selectedTab)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}


