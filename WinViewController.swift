//
//  WinViewController.swift
//  PolygonAttack
//
//  Created by Field Employee on 5/7/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

class WinViewController: UIViewController {
  var winner: Int?
  
  @IBOutlet weak var winLabel: UILabel!
  @IBAction func ReturnButton(_ sender: Any) {
    self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    winLabel.text = "Player \(winner!) Wins!"
  }
  
}
