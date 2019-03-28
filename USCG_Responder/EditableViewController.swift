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
    
    var mainDic = Dictionary<String,String>()
    
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

        self.idField.text = mainDic["id"]
        self.subFirstField.text = mainDic["perFirst"]
        self.subLastField.text = mainDic["perLast"]
        self.citField.text = mainDic["citizenship"]
        self.dobField.text = mainDic["DOB"]
        self.vesselField.text = mainDic["vessel"]
        self.regionField.text = mainDic["region"]
        self.latField.text = mainDic["intLat"]
        self.lonField.text = mainDic["intLon"]
        self.tsField.text = mainDic["timestampAscending"]
        self.mitFirstField.text = mainDic["subFirst"]
        self.mitLastField.text = mainDic["subLast"]
        self.notedView.text = mainDic["notes"]
    }

    
    @IBAction func returnButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "unwindToEditor", sender: self)
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
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        let ref: DatabaseReference = Database.database().reference(withPath: "case_reports").child("\(self.idField.text!)")
        ref.removeValue()
        
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
