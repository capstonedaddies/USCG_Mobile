//
//  VesselViewController.swift
//  USCG_Responder
//
//  Created by Mark Vainauskas on 3/28/19.
//  Copyright © 2019 Patrick Flynn. All rights reserved.
//

import UIKit
class VesselViewController:UIViewController{
    var firstName: String?
    var lastName: String?
    var email: String?
    var password: String?
    var dob: String?
    var address: String?
    var emergencyName: String?
    var emergencyPhone: String?
    @IBOutlet weak var vesselNo: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func next_button(_ sender: Any) {
        performSegue(withIdentifier: "vesselToProfileImage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "vesselToProfileImage" {
            let controller = segue.destination as! ProfilePictureViewController
            controller.firstName = firstName
            controller.lastName = lastName
            controller.email = email
            controller.password = password
            controller.dob = dob
            controller.address = address
            controller.emergencyName = emergencyName
            controller.emergencyPhone = emergencyPhone
            
            controller.vesselNo = vesselNo.text!
            
            
        }
    }
    
}
