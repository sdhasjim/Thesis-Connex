//
//  Task.swift
//  Thesis-Connex
//
//  Created by Samuel Dennis on 21/12/22.
//

import Foundation

struct Task: Identifiable, Equatable {
    
    var id: String
    var name: String
    var assignee: String
    var desc: String
    var priority: String
    var dueDate: String
    
    static func == (lhs: Task, rhs: Task) -> Bool {
            return lhs.id == rhs.id
        }
}
