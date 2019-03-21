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
    
    @IBOutlet weak var reportNumImg: UIImageView!
    @IBOutlet weak var reportNumButton: UIButton!
    
    
    //end hell
    
    //SUBJECT NAME VIEW ELEMENTS
    @IBOutlet weak var subNameView: UIView!
    @IBOutlet weak var subFirstField: UITextField!
    @IBOutlet weak var subLastField: UITextField!
    
    
    @IBOutlet weak var subjectFirstNameLabel: UILabel!
    
    @IBOutlet weak var subjectLastNameLabel: UILabel!
    
    @IBOutlet weak var subNameLimitField: UITextField!
    //END SUBJECT NAME VIEW ELEMENTS
    
    
    
    //MAIN VIEW UI ELEMENTS
    @IBOutlet weak var firstNameButton: UIButton!
    @IBOutlet weak var lastNameButton: UIButton!
    @IBOutlet weak var eitherButton: UIButton!
    @IBOutlet weak var bothButton: UIButton!
    
    @IBOutlet weak var oldestFirstButton: UIButton!
    
    @IBOutlet weak var newestFirstButton: UIButton!
    
    @IBOutlet weak var caseReportsButton: UIButton!
    
    @IBOutlet weak var NERButton: UIButton!
    
    @IBAction func newestFirstPressed(_ sender: Any) {
        oldestFirstButton.isSelected = false
        newestFirstButton.isSelected = true
    }
    @IBAction func oldestFirstPressed(_ sender: Any) {
        oldestFirstButton.isSelected = true
        newestFirstButton.isSelected = false
    }
    @IBAction func firstNamePressed(_ sender: Any) {
        firstNameButton.isSelected = true
        lastNameButton.isSelected = false
        eitherButton.isSelected = false
        bothButton.isSelected = false
    }
    @IBAction func lastNamePressed(_ sender: Any) {
        firstNameButton.isSelected = false
        lastNameButton.isSelected = false
        eitherButton.isSelected = true
        bothButton.isSelected = false
    }
    @IBAction func eitherPressed(_ sender: Any) {
        firstNameButton.isSelected = false
        lastNameButton.isSelected = false
        eitherButton.isSelected = true
        bothButton.isSelected = false
    }
    @IBAction func bothPressed(_ sender: Any) {
        firstNameButton.isSelected = false
        lastNameButton.isSelected = false
        eitherButton.isSelected = false
        bothButton.isSelected = true
    }
    
    //EZ QUERY VIEW
    @IBOutlet weak var ezQueryView: UIView!
    @IBOutlet weak var ezQueryField: UITextField!
    @IBOutlet weak var ezQueryLimit: UITextField!
    @IBOutlet weak var ezQueryTitle: UILabel!
    
    
    
    
    @IBAction func CRPressed(_ sender: Any) {
        caseReportsButton.isSelected = true
        NERButton.isSelected = false
    }
    
    @IBAction func NERPressed(_ sender: Any) {
        NERButton.isSelected = true
        caseReportsButton.isSelected = false
    }
    // MAIN VIEW ELEMENTS END
    
    
    
    var dicToPass = Dictionary<String, Dictionary<String,String>>()
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
        
        oldestFirstButton.setImage(#imageLiteral(resourceName: "Radio_Unchecked"), for: .normal)
        oldestFirstButton.setImage(#imageLiteral(resourceName: "Radio_Checked"), for: .selected)
        newestFirstButton.setImage(#imageLiteral(resourceName: "Radio_Unchecked"), for: .normal)
        newestFirstButton.setImage(#imageLiteral(resourceName: "Radio_Checked"), for: .selected)
        newestFirstButton.isSelected = true
        oldestFirstButton.isSelected = false
        
        firstNameButton.setImage(#imageLiteral(resourceName: "Radio_Checked"), for: .selected)
        firstNameButton.setImage(#imageLiteral(resourceName: "Radio_Unchecked"), for: .normal)
        lastNameButton.setImage(#imageLiteral(resourceName: "Radio_Checked"), for: .selected)
        lastNameButton.setImage(#imageLiteral(resourceName: "Radio_Unchecked"), for: .normal)
        eitherButton.setImage(#imageLiteral(resourceName: "Radio_Checked"), for: .selected)
        eitherButton.setImage(#imageLiteral(resourceName: "Radio_Unchecked"), for: .normal)
        bothButton.setImage(#imageLiteral(resourceName: "Radio_Checked"), for: .selected)
        bothButton.setImage(#imageLiteral(resourceName: "Radio_Unchecked"), for: .normal)
        
        
        ezQueryView.isHidden = true
        subNameButton.isSelected = true
        subNameImg.image = #imageLiteral(resourceName: "checkmark-1")
        
        //NERSubView.isHidden = true
        // END SET UP
        
        
        
        super.viewDidLoad()
    }
    
    //RETURN SEGUE
    @IBAction func ReturnButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "unwindToHomeFromRetrieval", sender: self)
    }
    
    
    //BIG BAD QUERY BUTTON
    @IBAction func SubmitQuery(_ sender: Any) {
        
        
        let ref: DatabaseReference = Database.database().reference(withPath: "case_reports")
        
        if subNameButton.isSelected{
            
            var weBoth:Bool = false
            var newref = DatabaseQuery()
            var secondref = DatabaseQuery()
            
            //DETERMINE LIMIT, IF ANY
            var limiter:UInt = 0
            if let limitText = subNameLimitField.text, !limitText.isEmpty{
                limiter = UInt(limitText)!
            }
            
            //IF WE ONLY CARE ABOUT FIRST NAME
            if firstNameButton.isSelected{
                if limiter == 0{
                    if oldestFirstButton.isSelected{
                        newref = ref.queryOrdered(byChild: "perFirst").queryEqual(toValue: subFirstField.text!).queryLimited(toLast:200)
                    }
                    else if newestFirstButton.isSelected{
                        newref = ref.queryOrdered(byChild: "perFirst").queryEqual(toValue: subFirstField.text!).queryLimited(toFirst:200)
                    }
                }
                else{
                    if oldestFirstButton.isSelected{
                        newref = ref.queryOrdered(byChild: "perFirst").queryEqual(toValue: subFirstField.text!).queryLimited(toLast:limiter)
                    }
                    else if newestFirstButton.isSelected{
                        newref = ref.queryOrdered(byChild: "perFirst").queryEqual(toValue: subFirstField.text!).queryLimited(toFirst:limiter)
                    }
                }
            }
            //IF WE ONLY CARE ABOUT LAST NAME
            else if lastNameButton.isSelected{
                if limiter == 0{
                    if oldestFirstButton.isSelected{
                        newref = ref.queryOrdered(byChild: "perLast").queryEqual(toValue: subLastField.text!).queryLimited(toLast:200)
                    }
                    else if newestFirstButton.isSelected{
                        newref = ref.queryOrdered(byChild: "perLast").queryEqual(toValue: subLastField.text!).queryLimited(toFirst:200)
                    }
                }
                else{
                    if oldestFirstButton.isSelected{
                        newref = ref.queryOrdered(byChild: "perLast").queryEqual(toValue: subLastField.text!).queryLimited(toLast:limiter)
                    }
                    else if newestFirstButton.isSelected{
                        newref = ref.queryOrdered(byChild: "perLast").queryEqual(toValue: subLastField.text!).queryLimited(toFirst:limiter)
                    }
                }
            }
            //IF WE CARE FOR EITHER
            else if eitherButton.isSelected{
                if limiter == 0{
                    if oldestFirstButton.isSelected{
                        newref = ref.queryOrdered(byChild: "perFirst").queryEqual(toValue: subFirstField.text!).queryLimited(toLast:100)
                        secondref = ref.queryOrdered(byChild: "perLast").queryEqual(toValue: subLastField.text!).queryLimited(toLast:100)
                    }
                    else if newestFirstButton.isSelected{
                        newref = ref.queryOrdered(byChild: "perFirst").queryEqual(toValue: subFirstField.text!).queryLimited(toFirst:100)
                        secondref = ref.queryOrdered(byChild: "perLast").queryEqual(toValue: subLastField.text!).queryLimited(toFirst:100)
                    }
                }
                else{
                    if oldestFirstButton.isSelected{
                        newref = ref.queryOrdered(byChild: "perFirst").queryEqual(toValue: subFirstField.text!).queryLimited(toLast:limiter)
                        secondref = ref.queryOrdered(byChild: "perLast").queryEqual(toValue: subLastField.text!).queryLimited(toLast:limiter)
                    }
                    else if newestFirstButton.isSelected{
                        newref = ref.queryOrdered(byChild: "perFirst").queryEqual(toValue: subFirstField.text!).queryLimited(toFirst:limiter)
                        secondref = ref.queryOrdered(byChild: "perLast").queryEqual(toValue: subLastField.text!).queryLimited(toFirst:limiter)
                    }
                }
            }
            //IF WE CARE ABOUT BOTH
            else if bothButton.isSelected{
                weBoth = true
                if limiter == 0{
                    if oldestFirstButton.isSelected{
                        newref = ref.queryOrdered(byChild: "perFirst").queryEqual(toValue: subFirstField.text!).queryLimited(toLast:200)
                    }
                    else if newestFirstButton.isSelected{
                        newref = ref.queryOrdered(byChild: "perFirst").queryEqual(toValue: subFirstField.text!).queryLimited(toFirst:200)
                    }
                }
                else{
                    if oldestFirstButton.isSelected{
                        newref = ref.queryOrdered(byChild: "perFirst").queryEqual(toValue: subFirstField.text!).queryLimited(toLast:limiter)
                    }
                    else if newestFirstButton.isSelected{
                        newref = ref.queryOrdered(byChild: "perFirst").queryEqual(toValue: subFirstField.text!).queryLimited(toFirst:limiter)
                    }
                }
            }
            
            if eitherButton.isSelected{
                newref.observe(.value, with:{ (snapshot: DataSnapshot) in
                    let queryResult = snapshot.valueInExportFormat()
                    let maybe = queryResult as? Dictionary<String,Dictionary<String,String>>
                    if maybe != nil{
                        for (id,report) in maybe!{
                            self.dicToPass[id] = report
                        }
                    }
                    secondref.observe(.value, with:{ (snapshot:DataSnapshot) in
                        let queryResult2 = snapshot.valueInExportFormat()
                        let maybe2 = queryResult2 as? Dictionary<String,Dictionary<String,String>>
                        if maybe2 != nil{
                            for (id,report) in maybe2!{
                                self.dicToPass[id] = report
                            }
                        }
                        self.goodToGo = true
                        self.performSegue(withIdentifier: "queryToTable", sender: Any?.self)
                    })
                    
                    
                })
            }
            else{
                newref.observe(.value, with:{ (snapshot: DataSnapshot) in
                    let queryResult = snapshot.valueInExportFormat()
                    print(queryResult!)
                    var maybe = queryResult as? Dictionary<String,Dictionary<String,String>>
                    if weBoth == true && maybe != nil{
                        maybe = self.bothStyle(lastToFind: self.subLastField.text!, payload: maybe!)
                    }
                    self.dicToPass = maybe!
                    self.goodToGo = true
                    self.performSegue(withIdentifier: "queryToTable", sender: Any?.self)
                    
                })
            }
        }
        else if citButton.isSelected{
            
            let ref: DatabaseReference = Database.database().reference(withPath: "case_reports")
        
            var newref = DatabaseQuery()

            //DETERMINE LIMIT, IF ANY
            var limiter:UInt = 0
            if let limitText = subNameLimitField.text, !limitText.isEmpty{
                limiter = UInt(limitText)!
            }
            
            if limiter == 0{
                if oldestFirstButton.isSelected{
                    newref = ref.queryOrdered(byChild: "citizenship").queryEqual(toValue: ezQueryField.text).queryLimited(toLast:200)
                }
                if newestFirstButton.isSelected{
                    newref = ref.queryOrdered(byChild: "citizenship").queryEqual(toValue: ezQueryField.text!).queryLimited(toLast:200)
                }
            }
            else{
                if oldestFirstButton.isSelected{
                    newref = ref.queryOrdered(byChild: "citizenship").queryEqual(toValue: ezQueryField.text).queryLimited(toLast:limiter)
                }
                if newestFirstButton.isSelected{
                    newref = ref.queryOrdered(byChild: "citizenship").queryEqual(toValue: ezQueryField.text!).queryLimited(toLast:limiter)
                }
            }
            
            
            newref.observe(.value, with:{ (snapshot: DataSnapshot) in
                let queryResult = snapshot.valueInExportFormat()
                print(queryResult!)
                let maybe = queryResult as? Dictionary<String,Dictionary<String,String>>
                self.dicToPass = maybe!
                self.goodToGo = true
                self.performSegue(withIdentifier: "queryToTable", sender: Any?.self)
                
            })
        }
        else if dobButton.isSelected{
            
        }
        else if regionButton.isSelected{
            let ref: DatabaseReference = Database.database().reference(withPath: "case_reports")
            
            var newref = DatabaseQuery()
            
            //DETERMINE LIMIT, IF ANY
            var limiter:UInt = 0
            if let limitText = subNameLimitField.text, !limitText.isEmpty{
                limiter = UInt(limitText)!
            }
            
            if limiter == 0{
                if oldestFirstButton.isSelected{
                    newref = ref.queryOrdered(byChild: "region").queryEqual(toValue: ezQueryField.text).queryLimited(toLast:200)
                }
                if newestFirstButton.isSelected{
                    newref = ref.queryOrdered(byChild: "region").queryEqual(toValue: ezQueryField.text!).queryLimited(toLast:200)
                }
            }
            else{
                if oldestFirstButton.isSelected{
                    newref = ref.queryOrdered(byChild: "region").queryEqual(toValue: ezQueryField.text).queryLimited(toLast:limiter)
                }
                if newestFirstButton.isSelected{
                    newref = ref.queryOrdered(byChild: "region").queryEqual(toValue: ezQueryField.text!).queryLimited(toLast:limiter)
                }
            }
            
            
            newref.observe(.value, with:{ (snapshot: DataSnapshot) in
                let queryResult = snapshot.valueInExportFormat()
                print(queryResult!)
                let maybe = queryResult as? Dictionary<String,Dictionary<String,String>>
                self.dicToPass = maybe!
                self.goodToGo = true
                self.performSegue(withIdentifier: "queryToTable", sender: Any?.self)
                
            })
        }
        else if vesselButton.isSelected{
            let ref: DatabaseReference = Database.database().reference(withPath: "case_reports")
            
            var newref = DatabaseQuery()
            
            //DETERMINE LIMIT, IF ANY
            var limiter:UInt = 0
            if let limitText = subNameLimitField.text, !limitText.isEmpty{
                limiter = UInt(limitText)!
            }
            
            if limiter == 0{
                if oldestFirstButton.isSelected{
                    newref = ref.queryOrdered(byChild: "vessel").queryEqual(toValue: ezQueryField.text).queryLimited(toLast:200)
                }
                if newestFirstButton.isSelected{
                    newref = ref.queryOrdered(byChild: "vessel").queryEqual(toValue: ezQueryField.text!).queryLimited(toLast:200)
                }
            }
            else{
                if oldestFirstButton.isSelected{
                    newref = ref.queryOrdered(byChild: "vessel").queryEqual(toValue: ezQueryField.text).queryLimited(toLast:limiter)
                }
                if newestFirstButton.isSelected{
                    newref = ref.queryOrdered(byChild: "vessel").queryEqual(toValue: ezQueryField.text!).queryLimited(toLast:limiter)
                }
            }
            
            
            newref.observe(.value, with:{ (snapshot: DataSnapshot) in
                let queryResult = snapshot.valueInExportFormat()
                print(queryResult!)
                let maybe = queryResult as? Dictionary<String,Dictionary<String,String>>
                self.dicToPass = maybe!
                self.goodToGo = true
                self.performSegue(withIdentifier: "queryToTable", sender: Any?.self)
                
            })
        }
        else if mitNameButton.isSelected{
            
            var weBoth:Bool = false
            var newref = DatabaseQuery()
            var secondref = DatabaseQuery()
            
            //DETERMINE LIMIT, IF ANY
            var limiter:UInt = 0
            if let limitText = subNameLimitField.text, !limitText.isEmpty{
                limiter = UInt(limitText)!
            }
            
            //IF WE ONLY CARE ABOUT FIRST NAME
            if firstNameButton.isSelected{
                if limiter == 0{
                    if oldestFirstButton.isSelected{
                        newref = ref.queryOrdered(byChild: "subFirst").queryEqual(toValue: subFirstField.text!).queryLimited(toLast:200)
                    }
                    else if newestFirstButton.isSelected{
                        newref = ref.queryOrdered(byChild: "subFirst").queryEqual(toValue: subFirstField.text!).queryLimited(toFirst:200)
                    }
                }
                else{
                    if oldestFirstButton.isSelected{
                        newref = ref.queryOrdered(byChild: "subFirst").queryEqual(toValue: subFirstField.text!).queryLimited(toLast:limiter)
                    }
                    else if newestFirstButton.isSelected{
                        newref = ref.queryOrdered(byChild: "subFirst").queryEqual(toValue: subFirstField.text!).queryLimited(toFirst:limiter)
                    }
                }
            }
                //IF WE ONLY CARE ABOUT LAST NAME
            else if lastNameButton.isSelected{
                if limiter == 0{
                    if oldestFirstButton.isSelected{
                        newref = ref.queryOrdered(byChild: "subLast").queryEqual(toValue: subLastField.text!).queryLimited(toLast:200)
                    }
                    else if newestFirstButton.isSelected{
                        newref = ref.queryOrdered(byChild: "subLast").queryEqual(toValue: subLastField.text!).queryLimited(toFirst:200)
                    }
                }
                else{
                    if oldestFirstButton.isSelected{
                        newref = ref.queryOrdered(byChild: "subLast").queryEqual(toValue: subLastField.text!).queryLimited(toLast:limiter)
                    }
                    else if newestFirstButton.isSelected{
                        newref = ref.queryOrdered(byChild: "subLast").queryEqual(toValue: subLastField.text!).queryLimited(toFirst:limiter)
                    }
                }
            }
                //IF WE CARE FOR EITHER
            else if eitherButton.isSelected{
                if limiter == 0{
                    if oldestFirstButton.isSelected{
                        newref = ref.queryOrdered(byChild: "subFirst").queryEqual(toValue: subFirstField.text!).queryLimited(toLast:100)
                        secondref = ref.queryOrdered(byChild: "subLast").queryEqual(toValue: subLastField.text!).queryLimited(toLast:100)
                    }
                    else if newestFirstButton.isSelected{
                        newref = ref.queryOrdered(byChild: "subFirst").queryEqual(toValue: subFirstField.text!).queryLimited(toFirst:100)
                        secondref = ref.queryOrdered(byChild: "subLast").queryEqual(toValue: subLastField.text!).queryLimited(toFirst:100)
                    }
                }
                else{
                    if oldestFirstButton.isSelected{
                        newref = ref.queryOrdered(byChild: "subFirst").queryEqual(toValue: subFirstField.text!).queryLimited(toLast:limiter)
                        secondref = ref.queryOrdered(byChild: "subLast").queryEqual(toValue: subLastField.text!).queryLimited(toLast:limiter)
                    }
                    else if newestFirstButton.isSelected{
                        newref = ref.queryOrdered(byChild: "subFirst").queryEqual(toValue: subFirstField.text!).queryLimited(toFirst:limiter)
                        secondref = ref.queryOrdered(byChild: "subLast").queryEqual(toValue: subLastField.text!).queryLimited(toFirst:limiter)
                    }
                }
            }
                //IF WE CARE ABOUT BOTH
            else if bothButton.isSelected{
                weBoth = true
                if limiter == 0{
                    if oldestFirstButton.isSelected{
                        newref = ref.queryOrdered(byChild: "subFirst").queryEqual(toValue: subFirstField.text!).queryLimited(toLast:200)
                    }
                    else if newestFirstButton.isSelected{
                        newref = ref.queryOrdered(byChild: "subFirst").queryEqual(toValue: subFirstField.text!).queryLimited(toFirst:200)
                    }
                }
                else{
                    if oldestFirstButton.isSelected{
                        newref = ref.queryOrdered(byChild: "subFirst").queryEqual(toValue: subFirstField.text!).queryLimited(toLast:limiter)
                    }
                    else if newestFirstButton.isSelected{
                        newref = ref.queryOrdered(byChild: "subFirst").queryEqual(toValue: subFirstField.text!).queryLimited(toFirst:limiter)
                    }
                }
            }
            
            if eitherButton.isSelected{
                newref.observe(.value, with:{ (snapshot: DataSnapshot) in
                    let queryResult = snapshot.valueInExportFormat()
                    let maybe = queryResult as? Dictionary<String,Dictionary<String,String>>
                    if maybe != nil{
                        for (id,report) in maybe!{
                            self.dicToPass[id] = report
                        }
                    }
                    secondref.observe(.value, with:{ (snapshot:DataSnapshot) in
                        let queryResult2 = snapshot.valueInExportFormat()
                        let maybe2 = queryResult2 as? Dictionary<String,Dictionary<String,String>>
                        if maybe2 != nil{
                            for (id,report) in maybe2!{
                                self.dicToPass[id] = report
                            }
                        }
                        self.goodToGo = true
                        self.performSegue(withIdentifier: "queryToTable", sender: Any?.self)
                    })
                    
                    
                })
            }
            else{
                newref.observe(.value, with:{ (snapshot: DataSnapshot) in
                    let queryResult = snapshot.valueInExportFormat()
                    print(queryResult!)
                    var maybe = queryResult as? Dictionary<String,Dictionary<String,String>>
                    if weBoth == true && maybe != nil{
                        maybe = self.bothStyle(lastToFind: self.subLastField.text!, payload: maybe!)
                    }
                    self.dicToPass = maybe!
                    self.goodToGo = true
                    self.performSegue(withIdentifier: "queryToTable", sender: Any?.self)
                    
                })
            }
        }
        else if caseReportsButton.isSelected{
            let ref: DatabaseReference = Database.database().reference(withPath: "case_reports")
            
            var newref = DatabaseQuery()
            
            //DETERMINE LIMIT, IF ANY
            var limiter:UInt = 0
            if let limitText = subNameLimitField.text, !limitText.isEmpty{
                limiter = UInt(limitText)!
            }
            
            if limiter == 0{
                if oldestFirstButton.isSelected{
                    newref = ref.queryOrdered(byChild: "id").queryEqual(toValue: ezQueryField.text).queryLimited(toLast:200)
                }
                if newestFirstButton.isSelected{
                    newref = ref.queryOrdered(byChild: "id").queryEqual(toValue: ezQueryField.text!).queryLimited(toLast:200)
                }
            }
            else{
                if oldestFirstButton.isSelected{
                    newref = ref.queryOrdered(byChild: "id").queryEqual(toValue: ezQueryField.text).queryLimited(toLast:limiter)
                }
                if newestFirstButton.isSelected{
                    newref = ref.queryOrdered(byChild: "id").queryEqual(toValue: ezQueryField.text!).queryLimited(toLast:limiter)
                }
            }
            
            
            newref.observe(.value, with:{ (snapshot: DataSnapshot) in
                let queryResult = snapshot.valueInExportFormat()
                print(queryResult!)
                let maybe = queryResult as? Dictionary<String,Dictionary<String,String>>
                self.dicToPass = maybe!
                self.goodToGo = true
                self.performSegue(withIdentifier: "queryToTable", sender: Any?.self)
                
            })
        }
        
        
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
            ezQueryView.isHidden = true
            subNameView.backgroundColor = subNameButton.backgroundColor
            subjectFirstNameLabel.text = "Subject First Name:"
            subjectLastNameLabel.text = "Subject Last Name:"
        }
        else{
            subNameImg.image = nil
            subNameButton.isSelected = false
        }
        if checked == 1{
            citImg.image = #imageLiteral(resourceName: "checkmark-1")
            ezQueryView.isHidden = false
            citButton.isSelected = true
            ezQueryView.backgroundColor = citButton.backgroundColor
            ezQueryTitle.text = "Subject Citizenship:"
            
        }
        else{
            citImg.image = nil
            citButton.isSelected = false
        }
        if checked == 2{
            dobImg.image = #imageLiteral(resourceName: "checkmark-1")
            ezQueryView.isHidden = true
            dobButton.isSelected = true
            
        }
        else{
            dobImg.image = nil
            dobButton.isSelected = false
        }
        if checked == 3{
            regionImg.image = #imageLiteral(resourceName: "checkmark-1")
            ezQueryView.isHidden = false
            regionButton.isSelected = true
            ezQueryView.backgroundColor = regionButton.backgroundColor
            ezQueryTitle.text = "Region Title:"
        }
        else{
            regionImg.image = nil
            regionButton.isSelected = false
        }
        if checked == 4{
            vesselImg.image = #imageLiteral(resourceName: "checkmark-1")
            ezQueryView.isHidden = false
            vesselButton.isSelected = true
            ezQueryView.backgroundColor = vesselButton.backgroundColor
            ezQueryTitle.text = "Vessel Name:"
        }
        else{
            vesselImg.image = nil
            vesselButton.isSelected = false
        }
        if checked == 5{
            mitNameImg.image = #imageLiteral(resourceName: "checkmark-1")
            subNameView.backgroundColor = mitNameButton.backgroundColor
            mitNameButton.isSelected = true
            ezQueryView.isHidden = true
            subjectFirstNameLabel.text = "Submitter First Name:"
            subjectLastNameLabel.text = "Submitter Last Name:"
        }
        else{
            mitNameImg.image = nil
            mitNameButton.isSelected = false
        }
        if checked == 7{
            reportNumImg.image = #imageLiteral(resourceName: "checkmark-1")
            ezQueryView.isHidden = false
            reportNumButton.isSelected = true
            ezQueryView.backgroundColor = reportNumButton.backgroundColor
            ezQueryTitle.text = "Case Report ID#:"
        }
        else{
            reportNumImg.image = nil
            reportNumButton.isSelected = false
        }
        
        
    }
    
    func bothStyle(lastToFind:String, payload: Dictionary<String,Dictionary<String,String>>) -> Dictionary<String,Dictionary<String,String>>{
        
        var bothFirstAndLast = Dictionary<String,Dictionary<String,String>>()
        
        for (id,report) in payload{
            if report["perLast"] == lastToFind{
                bothFirstAndLast[id] = report
            }
        }
        
        return bothFirstAndLast
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "queryToTable"{
            return goodToGo
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //HANDLE EMPTY RESULTS HERE
        
        
        let tableViewer = segue.destination as! QueryTableViewController
        tableViewer.passedInDicto = self.dicToPass
    }

}
