//
//  User.swift
//  Thesis-Connex
//
//  Created by Samuel Dennis on 25/12/22.
//

import Foundation

struct User: Identifiable, Equatable {
    
    var id: String
    var uid: String
    var username: String
    var email: String
    var profileImageUrl: String
    
    static func == (lhs: User, rhs: User) -> Bool {
            return lhs.id == rhs.id
        }
}

