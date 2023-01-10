//
//  Projects.swift
//  Thesis-Connex
//
//  Created by Samuel Dennis on 19/12/22.
//

import Foundation

struct Project: Identifiable, Equatable, Hashable {
    
    var id: String
    var name: String
    var desc: String
    var collaborator: [String]
    var status: String
    var uid: String
    var owner: String
    
    static func == (lhs: Project, rhs: Project) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
