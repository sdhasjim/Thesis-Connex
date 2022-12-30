//
//  ScoreViewModel.swift
//  Thesis-Connex
//
//  Created by Samuel Dennis on 28/12/22.
//

import Foundation

class ScoreViewModel: ObservableObject {
    
    @Published var scores = [Score]()
    
    func addData(projectID: String, userID: String, score: String, userStart: String, userStop: String, userContinue: String) {
        
        let db = FirebaseManager.shared.firestore
        
//        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let scoreData = ["userID": userID, "projectID": projectID, "score": [score], "userStart": [userStart], "userStop": [userStop], "userContinue": [userContinue]] as [String : Any]
        
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
}
