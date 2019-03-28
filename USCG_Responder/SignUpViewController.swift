//
//  SignUpViewController.swift
//  USCG_Responder
//
//  Created by Patrick Flynn on 2/11/19.
//  Copyright © 2019 Patrick Flynn. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    var handle:AuthStateDidChangeListenerHandle?
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // ...
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        messageLabel.isHidden = true
        
    }

    @IBAction func createAccount(_ sender: Any) {
        if emailField.text == nil || firstNameField.text == nil || lastNameField.text == nil || passwordField.text == nil{
            
            messageLabel.text = "One or more fields left blank. Please fill in the form and re-submit"
            messageLabel.isHidden = false
        }
        else {
            // Attempt to set Email.
            self.messageLabel.isHidden = false
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (authResult, error) in
                
                guard let user = authResult?.user
                    else {
                        self.messageLabel.isHidden = false
                        self.messageLabel.text = "Error Authenticating. Double check and try again."
                    return
                }
                Auth.auth().currentUser?.sendEmailVerification { (error) in
                    if error != nil{
                        print(error!)
                        self.messageLabel.isHidden = false
                        self.messageLabel.text = "Email verification failed. Please use valid Email address."
                    }
                    else{
                        self.messageLabel.isHidden = false
                        self.messageLabel.text = "Authentication email sent. Pleae check email and then try signing in."
                        
                        let myID = authResult?.user.uid
                        
                        let ref: DatabaseReference = Database.database().reference(withPath: "user_locations").child(myID!)
                        
                        let userCredentials = ["email":self.emailField.text!,
                                               "firstName": self.firstNameField.text!,
                                               "lastName": self.lastNameField.text!,
                                               "DOB": "01/01/1990",
                                               "Address": "123 Fake Street",
                                               "Emergency Contact Name": "John Jacob",
                                               "Emergency Contact": "1234567890",
                                               "Vessel No": "jdhdha374298fufh83",
                                               "Medical Notes": "Freckles"]
                        
                        ref.setValue(userCredentials);
                    }
                }
            }
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
