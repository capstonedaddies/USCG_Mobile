//
//  NameViewController.swift
//  USCG_Responder
//
//  Created by Mark Vainauskas on 3/28/19.
//  Copyright © 2019 Patrick Flynn. All rights reserved.
//

import UIKit
class NameViewController: UIViewController{
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    
    
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.navigationBar.isHidden = true
    
  }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func next_button(_ sender: Any) {
        performSegue(withIdentifier: "nameToEmail", sender: self)
    }
    @IBAction func cancel_pressed(_ sender: Any) {
      if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInVC") as? SignInViewController {
        if let navigator = navigationController {
          navigator.pushViewController(viewController, animated: true)
        }
      }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nameToEmail" {
            if firstName.text == nil || lastName.text == nil {
                //display error
            }else{
                let controller = segue.destination as! EmailViewController
                controller.firstName = firstName.text!
                controller.lastName = lastName.text!
                
            }
        }
    }
}
