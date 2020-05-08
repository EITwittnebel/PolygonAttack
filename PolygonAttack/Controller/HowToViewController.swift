//
//  HowToViewController.swift
//  PolygonAttack
//
//  Created by Field Employee on 5/7/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

class HowToViewController: UIViewController {

    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var fourthView: UIView!
    
    @IBOutlet weak var SegmentControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        
            SegmentControl.selectedSegmentIndex = 0
            firstView.alpha = 1
            secondView.alpha = 0
            thirdView.alpha = 0
            fourthView.alpha = 0
      
    }

    @IBAction func switchViews(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            firstView.alpha = 1
            secondView.alpha = 0
            thirdView.alpha = 0
            fourthView.alpha = 0
        } else if sender.selectedSegmentIndex == 1 {
            firstView.alpha = 0
            secondView.alpha = 1
            thirdView.alpha = 0
            fourthView.alpha = 0
        }
        else if sender.selectedSegmentIndex == 2 {
            firstView.alpha = 0
            secondView.alpha = 0
            thirdView.alpha = 1
            fourthView.alpha = 0
        }
        else if sender.selectedSegmentIndex == 3 {
                  firstView.alpha = 0
                  secondView.alpha = 0
                  thirdView.alpha = 0
                  fourthView.alpha = 1
              }
    }

}
