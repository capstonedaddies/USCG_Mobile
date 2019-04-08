//
//  EmailViewController.swift
//  USCG_Responder
//
//  Created by Mark Vainauskas on 3/28/19.
//  Copyright © 2019 Patrick Flynn. All rights reserved.
//

import UIKit

class EmailViewController: UIViewController{
    var firstName: String?
    var lastName: String?
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var retryPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func next_button(_ sender: Any) {
        if email.text == nil || password.text == nil || retryPassword.text == nil {
            //display compelete fields error
        }else if password.text! != retryPassword.text!{
            //display passwords dont match error
        }else{
            performSegue(withIdentifier: "emailToDOB", sender: self)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "emailToDOB" {
                let controller = segue.destination as! BirthViewController
                controller.firstName = firstName
                controller.lastName = lastName
                controller.email = email.text!
                controller.password = password.text!
        }
    }
    
    
}
