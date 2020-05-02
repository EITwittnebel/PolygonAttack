//
//  LoginViewController.swift
//  PolygonAttack
//
//  Created by Field Employee on 5/2/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {

    @IBOutlet weak var NameTextField: UITextField!
    
    @IBOutlet weak var PassTextField: UITextField!
    
    @IBOutlet weak var LoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func LoginButtonPress(_ sender: Any) {
        
        let username = NameTextField.text
        let password = PassTextField.text
        
        if username == "" || password == "" {
          let alert = UIAlertController(title: "Information", message: "Please enter all the fields", preferredStyle: .alert)

            let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)

            alert.addAction(ok)
            alert.addAction(cancel)

            self.present(alert, animated: true, completion: nil)
        }
        
        doLogin (username!, password!)
    }
    
    func doLogin (_ User: String,_ Pass:String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secVC = storyboard.instantiateViewController(identifier: "Main Page")
        
        self.present(secVC, animated: true, completion: nil)
    }
    

}
