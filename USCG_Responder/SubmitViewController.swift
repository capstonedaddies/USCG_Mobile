//
//  SubmitViewController.swift
//  USCG_Responder
//
//  Created by Patrick Flynn on 11/28/18.
//  Copyright © 2018 Patrick Flynn. All rights reserved.
//

import UIKit
import Firebase
import Photos

class SubmitViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var photoAdded = false
    var photoURL: String = ""
    
    let inserter = DBInt()
    let storage = Storage.storage()

    override func viewDidLoad() {
        super.viewDidLoad()

        noBlankText.isHidden = true
        successText.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // BEGIN - UI BADNESS
    
    @IBOutlet weak var successText: UILabel!
    @IBOutlet weak var noBlankText: UILabel!
    @IBOutlet weak var idText: UITextField!
    @IBOutlet weak var subFirstText: UITextField!
    @IBOutlet weak var subLastText: UITextField!
    @IBOutlet weak var regionText: UITextField!
    @IBOutlet weak var timestampText: UITextField!
    @IBOutlet weak var perpFirstText: UITextField!
    @IBOutlet weak var perpLastText: UITextField!
    @IBOutlet weak var perpDOBText: UITextField!
    @IBOutlet weak var perpCitizenshipText: UITextField!
    @IBOutlet weak var vesselText: UITextField!
    @IBOutlet weak var intLatText: UITextField!
    @IBOutlet weak var intLonText: UITextField!
    @IBOutlet weak var notesText: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    // END - UI BADNESS
    
    @IBAction func submitReport(_ sender: Any) {
    
        // OH JESUS, HERE WE GO
        
        // Create a new dict entry with info
        guard let uniqueID = idText.text else{
            noBlankText.isHidden = false
            successText.isHidden = true
            return
        }
        noBlankText.isHidden = true
        successText.isHidden = false
        
        var sf:String
        if subFirstText.text == nil{
            sf = ""
        }
        else{
            sf = subFirstText.text!
        }
        var sl: String
        if subLastText.text == nil{
            sl = ""
        }
        else{
            sl = subLastText.text!
        }
        var re: String
        if regionText.text == nil{
             re = ""
        }
        else{
             re = regionText.text!
        }
        var ts: String
        if timestampText.text == nil{
            ts = ""
        }
        else{
            ts = timestampText.text!
        }
        var pf: String
        if perpFirstText.text == nil{
            pf = ""
        }
        else{
           pf = perpFirstText.text!
        }
        var pl: String
        if perpLastText.text == nil{
            pl = ""
        }
        else{
            pl = perpLastText.text!
        }
        var pdob: String
        if perpDOBText.text == nil{
            pdob = ""
        }
        else{
            pdob = perpDOBText.text!
        }
        var pcit: String
        if perpCitizenshipText.text == nil{
            pcit = ""
        }
        else{
           pcit = perpCitizenshipText.text!
        }
        var ves: String
        if vesselText.text == nil{
            ves = ""
        }
        else{
           ves = vesselText.text!
        }
        var ilat: String
        if intLatText.text == nil{
            ilat = ""
        }
        else{
            ilat = intLatText.text!
        }
        var ilon: String
        if intLonText.text == nil{
            ilon = ""
        }
        else{
            ilon = intLonText.text!
        }
        var note: String
        if notesText.text == nil{
            note = ""
        }
        else{
           note = notesText.text!
        }
        var imgpat: String = ""
        
        // STORE IMAGES PORTTION
        if photoAdded == true{
        
            imgpat = photoURL

        }
        
        let newReport = CaseReport(id: uniqueID, subFirst: sf, subLast: sl, region: re, timestamp: ts, vessel: ves, perFirst: pf, perLast: pl, DOB: pdob, citizenship: pcit, intLat: ilat, intLon: ilon, notes: note, imagePath: imgpat)
        
        inserter.addRecord(record: newReport.toAnyObject())
        
        
    }
    
    @IBOutlet weak var addPhotoButton: UIButton!
    
    @IBAction func AddPhotoToReport(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            print("get a camera, loser")
            return
        }
        
        present(picker, animated: true, completion:nil)
    }
    
    @IBAction func returnButton(_ sender: Any) {
        performSegue(withIdentifier: "unwindToHomeFromSubmit", sender: self)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]){
        picker.dismiss(animated: true, completion:nil)
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        guard let imageData = UIImageJPEGRepresentation(image, 0.8) else { return }
        let imagePath = "caseReports/\(idText.text!)/photo1.jpg"
        self.photoURL = imagePath
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let storageRef = self.storage.reference(withPath: imagePath)
        storageRef.putData(imageData, metadata: metadata) { (metadata, error) in
            if let error = error {
                print("Error uploading: \(error)")
                return
            }
            return
        }
        self.photoAdded = true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion:nil)
    }
}
