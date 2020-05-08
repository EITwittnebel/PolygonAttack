//
//  LoginViewController.swift
//  PolygonAttack
//
//  Created by Field Employee on 5/2/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var PassTextField: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.NameTextField.delegate = self
        self.PassTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @IBAction func LoginButtonPress(_ sender: Any) {
        
        let username = NameTextField.text
        let password = PassTextField.text
        
        if username == "" || password == "" {
            displayAlert(AlertMessage: "Please enter information into all fields.")
        }
        
        doLogin (username!, password!)
    }
    
    func doLogin (_ User: String,_ Pass:String){
        
        if User == UserDefaults.standard.string(forKey: "username"){
            if Pass == UserDefaults.standard.string(forKey: "password"){
                Settings.userName = User
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let secVC = storyboard.instantiateViewController(identifier: "Main Page")
                secVC.modalPresentationStyle = .fullScreen
                self.present(secVC, animated: true, completion: nil)
            }
            
        }
        displayAlert(AlertMessage: "Either Username or Password don't match.")
        
    }
    
    func displayAlert(AlertMessage: String){
        let alert = UIAlertController(title: "Information", message: AlertMessage, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
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
