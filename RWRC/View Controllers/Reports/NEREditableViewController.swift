//
//  NEREditableViewController.swift
//  USCG_Responder
//
//  Created by Mark Vainauskas on 4/2/19.
//  Copyright © 2019 Patrick Flynn. All rights reserved.
//


//Where you make the edits and save them
import Foundation
import UIKit
import Firebase

class NEREditableViewController:UIViewController, UITextViewDelegate{
    var mainDic = Dictionary<String,Any>()
    
    @IBOutlet weak var id: UITextField!
    
    @IBOutlet weak var subjFirstName: UITextField!
    
    @IBOutlet weak var subjLastName: UITextField!
    @IBOutlet weak var region: UITextField!
    @IBOutlet weak var category: UITextField!
    @IBOutlet weak var timestamp: UITextField!
    @IBOutlet weak var descriptiontxt: UITextView!
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
        self.descriptiontxt.text = (mainDic["description"] as! String)
        
        //defines comments dictionary to add new element
        commentsDict = mainDic["comments"] as! Dictionary<String, Any>
        
        //to display to user current comments on NER
        for (_, comment) in commentsDict{
            comments.text += comment as! String + "\n"
        }
        comments.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        comments.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        comments.text = nil
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
    
    @IBAction func deleteReportBtnPressed(_ sender: Any) {
        let ref: DatabaseReference = Database.database().reference(withPath: "non_emergency_reports").child("\(self.id.text!)")
        ref.removeValue()
    }
    
    @IBAction func saveEditsPressed(_ sender: Any) {
        let ref: DatabaseReference = Database.database().reference(withPath: "non_emergency_reports")
        
        mainDic["id"] = self.id.text
        mainDic["subjectFirstName"] = self.subjFirstName.text
        mainDic["subjectLastName"] = self.subjLastName.text
        mainDic["region"] = self.region.text
        mainDic["category"] = self.category.text
        mainDic["timestamp"] = self.timestamp.text
        mainDic["description"] = self.descriptiontxt.text
        
        //adds new comment to the array
        let lastIndex = commentsDict.count+1
        commentsDict[String(lastIndex)] = self.comments.text

        mainDic["comments"] = commentsDict
        
        let newref = ref.child("\(self.id.text!)")
        newref.updateChildValues(mainDic)
    }
}
