//
//  Score.swift
//  Thesis-Connex
//
//  Created by Samuel Dennis on 28/12/22.
//

import Foundation

struct Score: Identifiable, Equatable {
    
    var id: String
    var projectID: String
    var userID: String
    var score: Int
    var userStart: String
    var userStop: String
    var userContinue: String
    
    static func == (lhs: Score, rhs: Score) -> Bool {
            return lhs.id == rhs.id
        }
}
