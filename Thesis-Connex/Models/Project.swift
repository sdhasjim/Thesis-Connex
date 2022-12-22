//
//  Projects.swift
//  Thesis-Connex
//
//  Created by Samuel Dennis on 19/12/22.
//

import Foundation

struct Project: Identifiable, Equatable {
    
    var id: String
    var name: String
    var desc: String
    var collaborator: [String]
    
    static func == (lhs: Project, rhs: Project) -> Bool {
            return lhs.id == rhs.id
        }
    
}
