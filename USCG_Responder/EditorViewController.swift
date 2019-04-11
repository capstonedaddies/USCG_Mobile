//
//  EditorViewController.swift
//  USCG_Responder
//
//  Created by Patrick Flynn on 3/19/19.
//  Copyright © 2019 Patrick Flynn. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController {
    
    var mainDic = Dictionary<String,String>()

    // UI WORK IS GETTING SO OLD
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var subFirstLabel: UILabel!
    @IBOutlet weak var subjectLastLabel: UILabel!
    
    @IBOutlet weak var citLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var vesselLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var lonLabel: UILabel!
    @IBOutlet weak var tsLabel: UILabel!
    @IBOutlet weak var mitFirstLabel: UILabel!
    @IBOutlet weak var mitLastLabel: UILabel!
    @IBOutlet weak var notesView: UITextView!
    @IBOutlet weak var mediaLabel: UILabel!
    
    
    
    
    
    // IM DONE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.idLabel.text = mainDic["id"]
        self.subFirstLabel.text = mainDic["perFirst"]
        self.subjectLastLabel.text = mainDic["perLast"]
        self.citLabel.text = mainDic["citizenship"]
        self.dobLabel.text = mainDic["DOB"]
        self.vesselLabel.text = mainDic["vessel"]
        self.regionLabel.text = mainDic["region"]
        self.latLabel.text = mainDic["intLat"]
        self.lonLabel.text = mainDic["intLon"]
        self.tsLabel.text = mainDic["timestampAscending"]
        self.mitFirstLabel.text = mainDic["subFirst"]
        self.mitLastLabel.text = mainDic["subLast"]
        self.notesView.text = mainDic["notes"]
    }

    @IBAction func editButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "editorToEditable", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editorToEditable"{
            let destination = segue.destination as! EditableViewController
            destination.mainDic = self.mainDic
        }
    }
    
    @IBAction func unwindToEditor(_ sender: UIStoryboardSegue){
        
    }
    
    @IBAction func returnButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "unwindToQueryTable", sender: self)
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
