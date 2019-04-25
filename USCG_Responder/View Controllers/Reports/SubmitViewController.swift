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
    
    var tsAscending: Double = 0.0
    var tsDescending: Double = 0.0
    
    let inserter = DBInt()
    let storage = Storage.storage()


    // BEGIN - UI BADNESS
    
    //CR STUFF
    @IBOutlet weak var idText: UITextField!
    @IBOutlet weak var subFirstText: UITextField!
    @IBOutlet weak var subLastText: UITextField!
    @IBOutlet weak var regionText: UITextField!
    @IBOutlet weak var timeStampText: UILabel!
    @IBOutlet weak var perpFirstText: UITextField!
    @IBOutlet weak var perpLastText: UITextField!
    @IBOutlet weak var perpDOBText: UITextField!
    @IBOutlet weak var perpCitizenshipText: UITextField!
    @IBOutlet weak var vesselText: UITextField!
    @IBOutlet weak var intLatText: UITextField!
    @IBOutlet weak var intLonText: UITextField!
    @IBOutlet weak var notesText: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var toggleReports: UISegmentedControl!
    @IBOutlet weak var crView: UIView!
    @IBOutlet weak var nerView: UIView!
    
    //NER STUFF
    @IBOutlet weak var nerToggleReports: UISegmentedControl!
    @IBOutlet weak var nerCaseID: UITextField!
    @IBOutlet weak var nerSubjFirstName: UITextField!
    @IBOutlet weak var nerSubjLastName: UITextField!
    @IBOutlet weak var nerRegion: UITextField!
    @IBOutlet weak var nerCategory: UITextField!
    @IBOutlet weak var nerNotes: UITextView!
    @IBOutlet weak var nerComments: UITextView!
    @IBOutlet weak var nerTimestampBtn: UIButton!
    @IBOutlet weak var nerTimestamp: UILabel!
    
    
    // END - UI BADNESS
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleReports.selectedSegmentIndex = 0
        nerView.isHidden = true
        nerView.isUserInteractionEnabled = false
        crView.isHidden = false
        crView.isUserInteractionEnabled = true
    }
    
    @IBAction func toggleReportsBtnPressed(_ sender: Any) {
        if toggleReports.selectedSegmentIndex == 1{
            //NER viewable
            crView.isUserInteractionEnabled = false
            crView.isHidden = true
            nerView.isHidden = false
            nerView.isUserInteractionEnabled = true
            
            nerToggleReports.selectedSegmentIndex = 1
            print(toggleReports.selectedSegmentIndex)
            print(nerToggleReports.selectedSegmentIndex)
        }
    }
    @IBAction func nerToggleReportsBtnPressed(_ sender: Any) {
        print(toggleReports.selectedSegmentIndex)
        print(nerToggleReports.selectedSegmentIndex)
        nerView.isUserInteractionEnabled = true

        if nerToggleReports.selectedSegmentIndex == 0{
            nerView.isHidden = true
            nerView.isUserInteractionEnabled = false
            crView.isUserInteractionEnabled = true
            crView.isHidden = false
            
            toggleReports.selectedSegmentIndex = 0
            print(toggleReports.selectedSegmentIndex)
            print(nerToggleReports.selectedSegmentIndex)
        }
    }
    
    @IBAction func nerSubmitBtn(_ sender: Any) {
        guard let uniqueID = nerCaseID.text else{
            
            messageNote(errorMessage: "Complete all fields. No blank text", title: "Error!")
            
            return
        }
        var sf:String
        if nerSubjFirstName.text == nil{
            sf = ""
        }
        else{
            sf = nerSubjFirstName.text!
        }
        var sl: String
        if nerSubjLastName.text == nil{
            sl = ""
        }
        else{
            sl = nerSubjLastName.text!
        }
        var re: String
        if nerRegion.text == nil{
            re = ""
        }
        else{
            re = nerRegion.text!
        }
        var tim: String = ""
        if nerTimestamp.text == "Please Generate Timestamp"{
            //generate timestamp here
            tim = genTimestamp()
        }
        var cat: String
        if nerCategory.text == nil{
            cat = ""
        }
        else{
            cat = nerCategory.text!
        }
        var not: String
        if nerNotes.text == nil{
            not = ""
        }
        else{
            not = nerNotes.text!
        }
        var comm: String
        if nerComments.text == nil{
            comm = ""
        }
        else{
            comm = nerComments.text!
        }
        
        if sf == "" || sl == "" || re == "" || cat == "" || not == "" || comm == "" {
            messageNote(errorMessage: "Complete all fields. No blank text", title: "Error!")
        }else{
            var commIn: Dictionary<String,Any>
                commIn = ["1": comm]
            let newReport = NonEmergencyReports(id: uniqueID, subjectFirstName: sf, subjectLastName: sl, region: re, category: cat, timestamp: tim, description: not, comment: commIn)
            
            inserter.addNERRecord(record: newReport.toAnyObject())
        }
    }
    @IBAction func submitReport(_ sender: Any) {
    
        // OH JESUS, HERE WE GO
        
        // Create a new dict entry with info
        guard let uniqueID = idText.text else{
            
            messageNote(errorMessage: "Complete all fields. No blank text", title: "Error!")
            
            return
        }
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
        if timeStampText.text == "Please Generate Timestamp"{
            messageNote(errorMessage: "Timestamp needed", title: "Error!")
            return
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
        
       messageNote(errorMessage: "Complete all fields. No blank text", title: "Error!")
        
        let newReport = CaseReport(id: uniqueID, subFirst: sf, subLast: sl, region: re, timestampAscending: String(self.tsAscending), timestampDescending: String(self.tsDescending), vessel: ves, perFirst: pf, perLast: pl, DOB: pdob, citizenship: pcit, intLat: ilat, intLon: ilon, notes: note, imagePath: imgpat)
        
        inserter.addRecord(record: newReport.toAnyObject())
        
        //segue to homeview
      if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainMenu") as? UITabBarController {
        if let navigator = navigationController {
          navigator.pushViewController(viewController, animated: true)
        }
      }
    }
    
    
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
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker.dismiss(animated: true, completion:nil)
        
        guard let image = info[.originalImage] as? UIImage else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
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
    
    @IBAction func generateTimestamp(_ sender: Any) {
        
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
        let year =  components.year!%2000
        let month = components.month!
        let day = components.day!
        let hour = components.hour!
        let minute = components.minute!
        
        self.tsAscending = Double((year*10000)+(month*1000)+(day*100)+(hour*10)+(minute))
        
        self.tsDescending = Double(1000/tsAscending)
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: date as Date)
        let yourDate: Date? = formatter.date(from: myString)
        timeStampText.text = myString
        
    }
    
    @IBAction func nerGenTimestamp(_ sender: Any) {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
        let year =  components.year!%2000
        let month = components.month!
        let day = components.day!
        let hour = components.hour!
        let minute = components.minute!
        
        self.tsAscending = Double((year*10000)+(month*1000)+(day*100)+(hour*10)+(minute))
        
        self.tsDescending = Double(1000/tsAscending)
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: date as Date)
        let yourDate: Date? = formatter.date(from: myString)
        timeStampText.text = myString
    }
    func genTimestamp()->String{
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
        let year =  components.year!%2000
        let month = components.month!
        let day = components.day!
        let hour = components.hour!
        let minute = components.minute!
        
        self.tsAscending = Double((year*10000)+(month*1000)+(day*100)+(hour*10)+(minute))
        
        self.tsDescending = Double(1000/tsAscending)
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: date as Date)
        let yourDate: Date? = formatter.date(from: myString)
        return myString
        
    }
    
    func messageNote(errorMessage:String, title:String){
        let alertController = UIAlertController(title: "Error!", message: errorMessage, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
        }))
        
        self.present(alertController,animated: true,completion: nil)
    }
    
    
}
