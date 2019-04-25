//
//  EditableViewController.swift
//  USCG_Responder
//
//  Created by Patrick Flynn on 3/19/19.
//  Copyright © 2019 Patrick Flynn. All rights reserved.
//

import UIKit
import Firebase

class EditableViewController: UIViewController {
    
    var mainDic = Dictionary<String,Any>()
    
    // Seriously, this needs to stop.
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var subFirstField: UITextField!
    @IBOutlet weak var subLastField: UITextField!
    @IBOutlet weak var citField: UITextField!
    @IBOutlet weak var dobField: UITextField!
    @IBOutlet weak var vesselField: UITextField!
    @IBOutlet weak var regionField: UITextField!
    @IBOutlet weak var latField: UITextField!
    @IBOutlet weak var lonField: UITextField!
    @IBOutlet weak var tsField: UITextField!
    @IBOutlet weak var mitFirstField: UITextField!
    @IBOutlet weak var mitLastField: UITextField!
    @IBOutlet weak var notedView: UITextView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.idField.text = mainDic["id"] as! String
        self.subFirstField.text = mainDic["perFirst"] as! String
        self.subLastField.text = mainDic["perLast"] as! String
        self.citField.text = mainDic["citizenship"] as! String
        self.dobField.text = mainDic["DOB"] as! String
        self.vesselField.text = mainDic["vessel"] as! String
        self.regionField.text = mainDic["region"] as! String
        self.latField.text = mainDic["intLat"] as! String
        self.lonField.text = mainDic["intLon"] as! String
        self.tsField.text = mainDic["timestampAscending"] as! String
        self.mitFirstField.text = mainDic["subFirst"] as! String
        self.mitLastField.text = mainDic["subLast"] as! String
        self.notedView.text = mainDic["notes"] as! String
    }

    
    @IBAction func saveButtonPressed(_ sender: Any) {
         let ref: DatabaseReference = Database.database().reference(withPath: "case_reports")
        
        mainDic["id"] = self.idField.text
        mainDic["perFirst"] = self.subFirstField.text
        mainDic["perLast"] = self.subLastField.text
        mainDic["citizenship"] = self.citField.text
        mainDic["DOB"] = self.dobField.text
        mainDic["vessel"] = self.vesselField.text
        mainDic["region"] = self.regionField.text
        mainDic["intLat"] = self.latField.text
        mainDic["intLon"] = self.lonField.text
        mainDic["timestampAscending"] = self.tsField.text
        mainDic["subFirst"] = self.mitFirstField.text
        mainDic["subLast"] = self.mitLastField.text
        mainDic["notes"] = self.notedView.text
        
        let newref = ref.child("\(self.idField.text!)")
        newref.updateChildValues(mainDic)
      
      if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainMenu") as? UITabBarController {
        if let navigator = navigationController {
          navigator.pushViewController(viewController, animated: true)
        }
      }
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        let ref: DatabaseReference = Database.database().reference(withPath: "case_reports").child("\(self.idField.text!)")
        ref.removeValue()
      
      if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainMenu") as? UITabBarController {
        if let navigator = navigationController {
          navigator.pushViewController(viewController, animated: true)
        }
      }
        
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
