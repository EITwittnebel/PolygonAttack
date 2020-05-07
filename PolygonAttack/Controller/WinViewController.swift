//
//  WinViewController.swift
//  PolygonAttack
//
//  Created by Field Employee on 5/7/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

import UIKit

class WinViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

  
    @IBAction func ReturnButton(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Main Page") as! ViewController

            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: false)
        }
    
    
}
