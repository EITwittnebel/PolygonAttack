//
//  WinViewController.swift
//  PolygonAttack
//
//  Created by Field Employee on 5/7/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit
import Firebase

class WinViewController: UIViewController {
  var winner: Int?
  
  @IBOutlet weak var winLabel: UILabel!
  @IBAction func ReturnButton(_ sender: Any) {
    self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    winLabel.text = "Player \(winner!) Wins!"
    
    let db = Firestore.firestore()
    let scoreRef = db.collection("leaderboard").document(Settings.userName)
    scoreRef.getDocument { (document, error) in
        let score: Int
        if let document = document,
            document.exists {
            let oldScore = document.data()!["score"] as! Int
            score = oldScore + 1
//            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//            print("Document data: \(dataDescription)")
        } else {
            score = 1
        }
        db.collection("leaderboard").document(Settings.userName).setData(["score": score]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            }
        }
    }
  }
  
}
