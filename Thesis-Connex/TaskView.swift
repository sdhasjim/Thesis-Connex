//
//  TaskView.swift
//  Thesis-Connex
//
//  Created by Jason Lauwrin on 02/11/22.
//

import SwiftUI

struct TaskView: View {
    @State var selectedTab = "task"
    var body: some View {
        ZStack{
            Color("yellow_tone").ignoresSafeArea()
            VStack{
                Text("task")
            }
        }
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView()
    }
}
