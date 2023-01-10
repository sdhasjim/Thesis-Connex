//
//  ScoreViewModel.swift
//  Thesis-Connex
//
//  Created by Samuel Dennis on 28/12/22.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore

class ScoreViewModel: ObservableObject {
    
    @Published var projectID: String?
    @Published var scores = [Score]()
    @Published var finalScore = 0
    @Published var progressValue: Float = 0.00
    
    func addData(projectID: String, userID: String, score: Int, userStart: String, userStop: String, userContinue: String) {
        
        let db = FirebaseManager.shared.firestore
        let userScore = Int(score)
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let scoreData = ["toUserID": userID, "projectID": projectID, "score": userScore , "userStart": userStart, "userStop": userStop, "userContinue": userContinue, "fromUserID": uid] as [String : Any]
        
        // update existing score
        if  let existingScoreIndex = scores.firstIndex(where: { $0.toUserID == userID }) {
            let existingScore = scores[existingScoreIndex]
            let docUpdateRef = db.collection("scores").document(existingScore.id).setData(scoreData) { [weak self] err in
                if let err = err {
                    print(err.localizedDescription)
                    return
                }
                self?.scores[existingScoreIndex].score = score
                self?.scores[existingScoreIndex].userStart = userStart
                self?.scores[existingScoreIndex].userStop = userStop
                self?.scores[existingScoreIndex].userContinue = userContinue
            }
        // insert new score
        } else {
            let docRef = db.collection("scores")
                .addDocument(data: scoreData) { [weak self] err in
                    if let err = err {
                        self?.scores.removeAll(where: { $0.toUserID == userID })
                        print(err.localizedDescription)
                        return
                    }
                    print("Success")
                }
            let newScoreEntry = Score(id: docRef.documentID, projectID: projectID, toUserID: userID, score: score, userStart: userStart, userStop: userStop, userContinue: userContinue, fromUserID: uid)
            scores.append(newScoreEntry)
        }
    }
    
    func scoreCalculation() {
        var userScore = [Int]()

        for sc in scores {
            print(sc.score)
            userScore.append(sc.score)
        }
        let sum = userScore.reduce(0, +)
        finalScore = userScore.count == 0 ? 0 : sum / userScore.count
        
        progressValue = Float(finalScore)
        progressValue = progressValue / 100
    }
    
    // klalau di score, score VM minta seluruh nilai yang dikasih dari user yg login ke user lainnya
    func getOutcomingDataFromProjectID(projectID: String, completion: (([Score]) -> Void)? = nil) {
        let db = FirebaseManager.shared.firestore
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let scoreRef = db.collection("scores")
        let query = scoreRef
            .whereField("projectID", isEqualTo: projectID)
            .whereField("fromUserID", isEqualTo: uid)
        processDataFromProjectID(query: query, completion: completion)
    }
    
    // kalau di profile, score VM ini akan minta seluruh nilai yang diberikan kepada user yg login
    func getIncomingDataFromProjectID(projectID: String) {
        let db = FirebaseManager.shared.firestore
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let scoreRef = db.collection("scores")
        let query = scoreRef
            .whereField("projectID", isEqualTo: projectID)
            .whereField("toUserID", isEqualTo: uid)
        processDataFromProjectID(query: query)
    }
    
    private func processDataFromProjectID(query: Query, completion: (([Score]) -> Void)? = nil) {
        query.addSnapshotListener { querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                    DispatchQueue.main.async {
                        let scores = querySnapshot!.documents.map { d in
                            
                            return Score(id: d.documentID,
                                         projectID: d["projectID"] as? String ?? "",
                                         toUserID: d["toUserID"] as? String ?? "",
                                         score: d["score"] as? Int ?? 0,
                                         userStart: d["userStart"] as? String ?? "",
                                         userStop: d["userStop"] as? String ?? "",
                                         userContinue: d["userContinue"] as? String ?? "",
                                         fromUserID: d["fromUserID"] as? String ?? ""
                            )
                        }
                        self.projectID =  self.scores.first?.projectID
                        self.scores = scores
                        self.scoreCalculation()
                        completion?(scores)
                    }
            }
        }
    }
}
