//
//  ProfileUser.swift
//  Thesis-Connex
//
//  Created by Samuel Dennis on 06/12/22.
//

import Foundation

struct ProfileUser {
    let uid, username, email, profileImageUrl: String
    
    init(data: [String: Any]) {
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
        self.username = data["username"] as? String ?? ""
    }
}
