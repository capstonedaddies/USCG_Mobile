//
//  RetrievalViewController.swift
//  USCG_Responder
//
//  Created by Patrick Flynn on 12/1/18.
//  Copyright © 2018 Patrick Flynn. All rights reserved.
//

import UIKit
import Firebase
import Foundation

class RetrievalViewController: UIViewController{
    
    
    // UI ELEMENTS
    
        // So many buttons, So many images
    @IBOutlet weak var subNameButton: UIButton!
    @IBOutlet weak var subNameImg: UIImageView!
    
    @IBOutlet weak var citButton: UIButton!
    @IBOutlet weak var citImg: UIImageView!
    
    @IBOutlet weak var dobButton: UIButton!
    @IBOutlet weak var dobImg: UIImageView!
    
    @IBOutlet weak var regionButton: UIButton!
    @IBOutlet weak var regionImg: UIImageView!
    
    @IBOutlet weak var vesselButton: UIButton!
    @IBOutlet weak var vesselImg: UIImageView!
    
    @IBOutlet weak var mitNameButton: UIButton!
    @IBOutlet weak var mitNameImg: UIImageView!
    
    @IBOutlet weak var tsButton: UIButton!
    @IBOutlet weak var tsImg: UIImageView!
    
    @IBOutlet weak var reportNumImg: UIImageView!
    
        //end hell
    
    @IBOutlet weak var caseReportsButton: UIButton!
    
    @IBOutlet weak var NERButton: UIButton!
    
    @IBOutlet weak var NERSubView: UIView!
    
    @IBAction func CRPressed(_ sender: Any) {
        
        caseReportsButton.isSelected = true
        NERButton.isSelected = false
        //NERSubView.isHidden = true

    }
    
    @IBAction func NERPressed(_ sender: Any) {
        
        NERButton.isSelected = true
        caseReportsButton.isSelected = false
        //NERSubView.isHidden = false
        
    }
    
    
    var dicToPass: Dictionary<String, Dictionary<String,String>>?
    var goodToGo:Bool = false
    var pickerData: [String] = [String]()
    let DBRef = DBInt()
    var checkList: [UIImageView] = [UIImageView]()
    
    override func viewDidLoad() {
        
        self.goodToGo = false
        
        
        // SET UP BUTTONS AND SUBVIEWS ON INIT
        caseReportsButton.setImage(#imageLiteral(resourceName: "Radio_Unchecked"), for: .normal)
        caseReportsButton.setImage(#imageLiteral(resourceName: "Radio_Checked"), for: .selected)
        NERButton.setImage(#imageLiteral(resourceName: "Radio_Unchecked"), for: .normal)
        NERButton.setImage(#imageLiteral(resourceName: "Radio_Checked"), for: .selected)
        caseReportsButton.isSelected = true
        NERButton.isSelected = false
        //NERSubView.isHidden = true
        // END SET UP
        
        
        
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ReturnButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "unwindToHomeFromRetrieval", sender: self)
    }
    
    @IBAction func SubmitQuery(_ sender: Any) {
        
        
        var ref: DatabaseReference = Database.database().reference(withPath: "case_reports")
        
        /*if  key == "ID Number"{
            
            ref = ref.child(valueField.text!)
            _ = ref.queryOrderedByKey().queryEqual(toValue: valueField.text!)
            
            ref.observe(.value, with:{ (snapshot: DataSnapshot) in
                let queryResult = snapshot.valueInExportFormat()
                print(queryResult!)
                let dicto = queryResult as! Dictionary<String, Dictionary<String,String>>
                self.dicToPass = dicto
                self.performSegue(withIdentifier: "queryToTable", sender: Any?.self)
                
                for dicKey in dicto{
                    
                    self.textBox.text.append("\(dicKey.key) : \(dicKey.value)\n")
                    
                }
            })

        }
        else if  key != "ID Number"{
            
            let newref = ref.queryOrdered(byChild: "region").queryEqual(toValue: "Gilbert")
            
            newref.observe(.value, with:{ (snapshot: DataSnapshot) in
                let queryResult = snapshot.valueInExportFormat()
                print(queryResult!)
                let maybe = queryResult as! Dictionary<String,Dictionary<String,String>>
                self.dicToPass = maybe
                self.goodToGo = true
                self.performSegue(withIdentifier: "queryToTable", sender: Any?.self)
                
            })
            
        }
        else{
            print("Bad Job")
        }
        */
    }
    
    @IBAction func fieldSelected(_ sender: Any) {
        guard let button = sender as? UIButton else{
            print("UBAD")
            return
        }
        self.cycleChecks(checked: button.tag)
    }
    
    func cycleChecks(checked: Int){
        
        if checked == 0{
            subNameImg.image = #imageLiteral(resourceName: "checkmark-1")
        }
        else{
            subNameImg.image = nil
        }
        if checked == 1{
            citImg.image = #imageLiteral(resourceName: "checkmark-1")
        }
        else{
            citImg.image = nil
        }
        if checked == 2{
            dobImg.image = #imageLiteral(resourceName: "checkmark-1")
        }
        else{
            dobImg.image = nil
        }
        if checked == 3{
            regionImg.image = #imageLiteral(resourceName: "checkmark-1")
        }
        else{
            regionImg.image = nil
        }
        if checked == 4{
            vesselImg.image = #imageLiteral(resourceName: "checkmark-1")
        }
        else{
            vesselImg.image = nil
        }
        if checked == 5{
            mitNameImg.image = #imageLiteral(resourceName: "checkmark-1")
        }
        else{
            mitNameImg.image = nil
        }
        if checked == 6{
            tsImg.image = #imageLiteral(resourceName: "checkmark-1")
        }
        else{
            tsImg.image = nil
        }
        if checked == 7{
            reportNumImg.image = #imageLiteral(resourceName: "checkmark-1")
        }
        else{
            reportNumImg.image = nil
        }
        
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "queryToTable"{
            return goodToGo
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tableViewer = segue.destination as! QueryTableViewController
        tableViewer.passedInDicto = self.dicToPass
    }

    
}
