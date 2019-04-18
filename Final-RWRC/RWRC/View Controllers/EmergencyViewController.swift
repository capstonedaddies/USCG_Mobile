//
//  EmergencyViewController.swift
//  USCG_Responder
//
//  Created by Mark Vainauskas on 3/28/19.
//  Copyright © 2019 Patrick Flynn. All rights reserved.
//

import UIKit
class EmergencyViewController:UIViewController{
    var firstName: String?
    var lastName: String?
    var email: String?
    var password: String?
    var dob: String?
    var address: String?
    
    @IBOutlet weak var emergencyName: UITextField!
    @IBOutlet weak var emergencyPhone: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func next_button(_ sender: Any) {
        performSegue(withIdentifier: "emergencyToVessel", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "emergencyToVessel" {
            let controller = segue.destination as! VesselViewController
            controller.firstName = firstName
            controller.lastName = lastName
            controller.email = email
            controller.password = password
            controller.dob = dob
            controller.address = address
            
            controller.emergencyName = emergencyName.text!
            controller.emergencyPhone = emergencyPhone.text!
            
            
        }
    }
}
