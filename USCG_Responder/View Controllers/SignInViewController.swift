//
//  SignInViewController.swift
//  USCG_Responder
//
//  Created by Patrick Flynn on 2/11/19.
//  Copyright © 2019 Patrick Flynn. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {

    var handle:AuthStateDidChangeListenerHandle?
    var shouldSegueFromLogin = false
    
    @IBOutlet weak var noBlank: UILabel!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        noBlank.isHidden = true
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
  

    
    // UI ELEMENTS BEGIN
    
    @IBOutlet weak var passLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBAction func autoFillPressed(_ sender: Any) {
        emailLabel.text = "mrvainau@asu.edu"
        passLabel.text = "abcd1234"
    }
  
   
    @IBAction func signInButton(_ sender: Any) {
        self.performSegue(withIdentifier: "signInToSignUp", sender: self)
    }
    
    @IBAction func loginButton(_ sender: Any) {
        if passLabel.text == nil || emailLabel.text == nil{
            noBlank.isHidden = false
            noBlank.text = "Email/Password cannot be blank!"
        }
        else{
            Auth.auth().signIn(withEmail: emailLabel.text!, password: passLabel.text!) { (user, error) in
                if error != nil{
                    self.noBlank.isHidden = false
                    self.noBlank.text = "Email/Password not recognized!"
                }
                else{
                    if (Auth.auth().currentUser?.isEmailVerified)!{
                      
                        AppSettings.displayName = Auth.auth().currentUser?.email
                        AppSettings.uid = Auth.auth().currentUser?.uid
                        self.noBlank.text = ""
                        self.noBlank.isHidden = true
                        self.performSegue(withIdentifier: "signInToMain", sender: self)
                    }
                    else{
                        self.noBlank.isHidden = false
                        self.noBlank.text = "Email not verified. Please check email (inbox and junk folder)"
                    }
                    
                }
                
            }
        }
    }
    
    // UI ELEMENTS END
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logInToMain" {
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
      self.navigationController?.navigationBar.isHidden = true

        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // ...
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
