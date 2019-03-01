//
//  SignupViewController.swift
//  USCG_Responder
//
//  Created by Mark Vainauskas on 2/8/19.
//  Copyright © 2019 Patrick Flynn. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController{
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var dob: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToHomePage(segue: UIStoryboardSegue){
        // perhaps do some things
    }
    
}
