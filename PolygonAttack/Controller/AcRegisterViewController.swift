//
//  AcRegisterViewController.swift
//  PolygonAttack
//
//  Created by Field Employee on 5/2/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit
import CoreData

class AcRegisterViewController: UIViewController, UITextFieldDelegate {

  @IBOutlet var NameTextField: UITextField!

    @IBOutlet var PassTextField: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()

        self.NameTextField.delegate = self
        self.PassTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @IBAction func register(_ sender: Any)
    {
        if NameTextField.text == "" || PassTextField.text == ""
        {
            let alert = UIAlertController(title: "Information", message: "Its Mandatory to enter all the fields", preferredStyle: .alert)

            let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)

            alert.addAction(ok)
            alert.addAction(cancel)

            self.present(alert, animated: true, completion: nil)
            return

        }
        
        UserDefaults.standard.set(NameTextField.text, forKey: "username")
        UserDefaults.standard.set(PassTextField.text, forKey: "password")
        UserDefaults.standard.synchronize()
        
        let alert = UIAlertController(title: "Information", message: "Account Created successfully.", preferredStyle: .alert)

        let ok = UIAlertAction(title: "Ok", style: .default){ action in
            self.dismiss(animated: true)
        }
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
        

        }
    
    @IBAction func ReturnButton(_ sender: Any) {
        self.dismiss(animated: true)
        return
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           self.view.endEditing(true)
           return false
       }
       
       @objc func keyboardWillShow(notification: NSNotification) {
           if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
               if self.view.frame.origin.y == 0 {
                   self.view.frame.origin.y -= keyboardSize.height
               }
           }
       }
       @objc func keyboardWillHide(notification: NSNotification) {
           if self.view.frame.origin.y != 0 {
               self.view.frame.origin.y = 0
           }
       }
    
}
