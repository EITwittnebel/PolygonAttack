//
//  LeaderboardTableViewController.swift
//  PolygonAttack
//
//  Created by Gavin Li on 5/8/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit
import Firebase

class LeaderboardTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let db = Firestore.firestore()
        db.collection("leaderboard").getDocuments() { [weak self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self?.scoreData.append((document.documentID, document.data()["score"] as! Int))
//                    print("\(document.documentID) => \(document.data())")
                }
                self?.scoreData.sort(by: { $0.1 > $1.1 })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Table view data source
    var scoreData: [(String, Int)] = []

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoreData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scoreDataCell", for: indexPath)

        let aScore = scoreData[indexPath.row]
        cell.textLabel?.text = aScore.0
        cell.detailTextLabel?.text = "Score: \(aScore.1)"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
