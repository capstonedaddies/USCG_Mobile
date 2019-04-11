//
//  EditorViewController.swift
//  USCG_Responder
//
//  Created by Patrick Flynn on 3/19/19.
//  Copyright © 2019 Patrick Flynn. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController {
    
    var mainDic = Dictionary<String,Any>()

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
        
        self.idLabel.text = (mainDic["id"] as! String)
        self.subFirstLabel.text = (mainDic["perFirst"] as! String)
        self.subjectLastLabel.text = (mainDic["perLast"] as! String)
        self.citLabel.text = (mainDic["citizenship"] as! String)
        self.dobLabel.text = (mainDic["DOB"] as! String)
        self.vesselLabel.text = (mainDic["vessel"] as! String)
        self.regionLabel.text = (mainDic["region"] as! String)
        self.latLabel.text = (mainDic["intLat"] as! String)
        self.lonLabel.text = (mainDic["intLon"] as! String)
        self.tsLabel.text = (mainDic["timestampAscending"] as! String)
        self.mitFirstLabel.text = (mainDic["subFirst"] as! String)
        self.mitLastLabel.text = (mainDic["subLast"] as! String)
        self.notesView.text = (mainDic["notes"] as! String)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
