//
//  NEREditorViewController.swift
//  USCG_Responder
//
//  Created by Mark Vainauskas on 4/2/19.
//  Copyright © 2019 Patrick Flynn. All rights reserved.
//

import Foundation
import UIKit

class NEREditorViewController:UIViewController, UITextViewDelegate{
     var mainDic = Dictionary<String,Any>()
    @IBOutlet weak var id: UITextField!
    @IBOutlet weak var subjFirstName: UITextField!
    @IBOutlet weak var subjLastName: UITextField!
    @IBOutlet weak var region: UITextField!
    @IBOutlet weak var category: UITextField!
    @IBOutlet weak var timestamp: UITextField!
    @IBOutlet weak var descriptionTxt: UITextView!
    
    @IBOutlet weak var comments: UITextView!

    var commentsDict = Dictionary<String,Any>()
    
    override func viewDidLoad() {
        comments.delegate = self
        
        self.id.text = (mainDic["id"] as! String)
        self.subjFirstName.text = (mainDic["subjectFirstName"] as! String)
        self.subjLastName.text = (mainDic["subjectLastName"] as! String)
        self.region.text = (mainDic["region"] as! String)
        self.category.text = (mainDic["category"] as! String)
        self.timestamp.text = (mainDic["timestamp"] as! String)
        self.descriptionTxt.text = (mainDic["description"] as! String)
        
        //defines comments dictionary to add new element
        commentsDict = mainDic["comments"] as! Dictionary<String, Any>
        
        //to display to user current comments on NER
        for (_, comment) in commentsDict{
            comments.text += comment as! String + "\n"
        }
        comments.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    @IBAction func editBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "nerViewToEdit", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nerViewToEdit"{
            let destination = segue.destination as! NEREditableViewController
            destination.mainDic = self.mainDic
        }
    }
    
    
}
