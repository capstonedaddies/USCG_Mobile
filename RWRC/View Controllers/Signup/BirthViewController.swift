//
//  BirthViewController.swift
//  USCG_Responder
//
//  Created by Mark Vainauskas on 3/28/19.
//  Copyright © 2019 Patrick Flynn. All rights reserved.
//

import UIKit

class BirthViewController: UIViewController{
    var firstName: String?
    var lastName: String?
    var email: String?
    var password: String?
    
    @IBOutlet weak var dob: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func next_button(_ sender: Any) {
        performSegue(withIdentifier: "dobToAddress", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dobToAddress" {
                let controller = segue.destination as! AddressViewController
                controller.firstName = firstName
                controller.lastName = lastName
                controller.email = email
                controller.password = password
            
                let dateFormatr = DateFormatter()
                dateFormatr.dateFormat = "MM-dd-yyyy"
                let strDate = dateFormatr.string(from: (dob?.date)!)
            
                controller.dob = strDate

            
        }
    }
}
