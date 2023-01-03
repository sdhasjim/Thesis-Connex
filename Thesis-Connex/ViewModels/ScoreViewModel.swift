//
//  ScoreViewModel.swift
//  Thesis-Connex
//
//  Created by Samuel Dennis on 28/12/22.
//

import Foundation

class ScoreViewModel: ObservableObject {
    
    @Published var scores = [Score]()
    @Published var finalScore = 0
    @Published var progressValue: Float = 0.00
    
    func addData(projectID: String, userID: String, score: String, userStart: String, userStop: String, userContinue: String) {
        
        let db = FirebaseManager.shared.firestore
        let userScore = Int(score)
        
//        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let scoreData = ["userID": userID, "projectID": projectID, "score": userScore ?? 0, "userStart": userStart, "userStop": userStop, "userContinue": userContinue] as [String : Any]
        
        db.collection("scores")
            .addDocument(data: scoreData) { err in
                if let err = err {
                    print(err)
                    return
                }
                
//                self.getDataFromProjectID(projectID: projectID)
                print("Success")
            }
    }
    
    func scoreCalculation() {
        var userScore = [Int]()

        for sc in scores {
            print(sc.score)
            userScore.append(sc.score)
        }
        print(userScore)
        let sum = userScore.reduce(0, +)
        finalScore = sum / userScore.count
        
        progressValue = Float(finalScore)
        progressValue = progressValue / 100

        print(finalScore)
        print(progressValue)
    }
    
    func getDataFromProjectID(projectID: String) {
        let db = FirebaseManager.shared.firestore
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let scoreRef = db.collection("scores")
        
        let query =
        scoreRef
            .whereField("projectID", isEqualTo: projectID)
            .whereField("userID", isEqualTo: uid)
        
        query.addSnapshotListener { querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                    DispatchQueue.main.async {
                        self.scores = querySnapshot!.documents.map { d in
                            
                            return Score(id: d.documentID,
                                         projectID: d["projectID"] as? String ?? "",
                                         userID: d["userID"] as? String ?? "",
                                         score: d["score"] as? Int ?? 0,
                                         userStart: d["userStart"] as? String ?? "",
                                         userStop: d["userStop"] as? String ?? "",
                                         userContinue: d["userContinue"] as? String ?? ""
                            )
                        }
                        self.scoreCalculation()
                    }
            }
        }
    }
}
