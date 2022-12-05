//
//  NewProject.swift
//  Thesis-Connex
//
//  Created by Jason Lauwrin on 02/12/22.
//

import SwiftUI

struct NewProject : View{
    
//    @State var nativeAlert = false
    @State var customAlert = false
    @State var HUD = false
    @State var password = ""
    
    var body: some View{
        ZStack{
            VStack(spacing: 25){
                Button(action: {
                    
//                    withAnimation{
//                        nativeAlert.toggle()
//                    }
                    alertView()
                    
                }){
                    Text("Native alert with Text")
                }
                Text(password).fontWeight(.bold)
            }
        }
    }
    
    func alertView(){
        let alert = UIAlertController(title: "login", message: "enter your pass", preferredStyle: .alert)
        
        alert.addTextField{(pass) in
            pass.isSecureTextEntry = true
            pass.placeholder = "Pass"
            
        }
        
        let login = UIAlertAction(title: "Login", style: .default){(_) in
            //do yiur own stuff
            
            //retrieving password
            password = alert.textFields![0].text!
        }
        
        let cancel = UIAlertAction(title: "cancel", style: .destructive){(_) in
            //same
        }
        
        //adding into alertview
        alert.addAction(cancel)
        
        alert.addAction(login)
        
        //presenting alertView
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: {
            //do your own
        })
    }
}

struct NewProjectView_Previews: PreviewProvider {
    static var previews: some View {
        NewProject()
    }
}
