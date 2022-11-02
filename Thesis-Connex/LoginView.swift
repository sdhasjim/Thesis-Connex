//
//  Login.swift
//  Thesis-Connex
//
//  Created by Jason Lauwrin on 26/10/22.
//

import SwiftUI

struct LoginView: View {
    @State var isLoginMode = true
    @State var createName = ""
    @State var createEmail = ""
    @State var createPassword = ""
    @State var passwordValidator = ""
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                VStack(spacing: 16) {
                    Picker(selection: $isLoginMode, label: Text("Picker here")) {
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                    
//                    if !isLoginMode {
//                        Button {
//
//                        } label: {
//                            Image(systemName: "person.fill")
//                                .font(.system(size: 64))
//                                .padding()
//                        }
//                    }
                    
                    Group {
                        if isLoginMode {
                            TextField("Email", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)

                            SecureInputView("Password", text: $password)
                        } else {
                            TextField("Name", text: $createName)
                                .autocapitalization(.none)
                            
                            TextField("Email", text: $createEmail)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)

                            SecureField("Password", text: $createPassword)
                            SecureField("Confirm Password", text: $passwordValidator)
                        }

                        

                    }
                    .padding(9)
                    .foregroundColor(.black)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)

                    Button {
                        handleAction()
                    } label: {
                        HStack {
                            Spacer()
                            Text(isLoginMode ? "Login" : "Create Account")
                                .foregroundColor(.black.opacity(0.6))
                                .padding(.vertical, 10)
                                .font(.system(size: 14, weight: .semibold))
                            Spacer()
                        }
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    }
                }
                .padding()
                
            }
            .navigationTitle(isLoginMode ? "Login" : "Create Account")
            .background(Color("yellow_tone")
                .ignoresSafeArea())
        }
    }
    
    private func handleAction() {
        if isLoginMode {
            print("Should log into Firebase with existing credentials")
        } else {
            print("Register a new account inside of Firebase Auth and then store image in Storage")
        }
    }
    
}

struct SecureInputView: View {
    
    @Binding private var text: String
    @State private var isSecured: Bool = true
    private var title: String
    
    init(_ title: String, text: Binding<String>) {
        self.title = title
        self._text = text
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            Group {
                if isSecured {
                    SecureField(title, text: $text)
                } else {
                    TextField(title, text: $text)
                }
            }

            Button(action: {
                isSecured.toggle()
            }) {
                Image(systemName: self.isSecured ? "eye.slash" : "eye")
                    .accentColor(.gray)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
