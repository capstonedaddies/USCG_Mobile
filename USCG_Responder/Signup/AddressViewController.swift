//
//  AddressViewController.swift
//  USCG_Responder
//
//  Created by Mark Vainauskas on 3/28/19.
//  Copyright © 2019 Patrick Flynn. All rights reserved.
//

import UIKit

class AddressViewController:UIViewController{
    var firstName: String?
    var lastName: String?
    var email: String?
    var password: String?
    var dob: String?
    
    @IBOutlet weak var address: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func next_button(_ sender: Any) {
        performSegue(withIdentifier: "addressToEmergency", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addressToEmergency" {
            let controller = segue.destination as! EmergencyViewController
            controller.firstName = firstName
            controller.lastName = lastName
            controller.email = email
            controller.password = password
            controller.dob = dob
            controller.address = address.text!
            
            
        }
    }
}
