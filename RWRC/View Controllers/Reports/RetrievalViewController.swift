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
        ezQueryView.isHidden = true

        
        
        //Hide NER Buttons
        nerMainView.isHidden = true
        nerRegionBtn.isSelected = false
        nerRegionImg.image = nil
        
        nerCategoryBtn.isSelected = false
        nerCategoryImg.image = nil
        
        nerSubjectBtn.isSelected = false
        nerRegionBtn.isEnabled = false
        nerCategoryBtn.isEnabled = false
        nerSubjectBtn.isEnabled = false
        nerSubjectImg.image = nil
        
        
        //unhide CR buttons
        subNameButton.isHidden = false
        subNameImg.isHidden = false
        subNameButton.isEnabled = true
        
        citButton.isHidden = false
        citImg.isHidden = false
        citButton.isEnabled = true
        
        dobButton.isHidden = false
        dobImg.isHidden = false
        dobButton.isEnabled = true

        regionButton.isHidden = false
        regionImg.isHidden = false
        regionButton.isEnabled = true

        vesselButton.isHidden = false
        vesselImg.isHidden = false
        vesselButton.isEnabled = true

        mitNameButton.isHidden = false
        mitNameImg.isHidden = false
        mitNameButton.isEnabled = true
        
        reportNumButton.isHidden = false
        reportNumImg.isHidden = false
        reportNumButton.isEnabled = true
        
        subNameButton.isSelected = true
        subNameImg.image = #imageLiteral(resourceName: "checkmark-1")

    }
    
    @IBAction func NERPressed(_ sender: Any) {
        NERButton.isSelected = true
        caseReportsButton.isSelected = false
        ezQueryView.isHidden = false
        

        //unhide NER Buttons
        nerMainView.isHidden = false
        nerRegionBtn.isEnabled = true
        nerCategoryBtn.isEnabled = true
        nerSubjectBtn.isEnabled = true
        
        nerRegionBtn.isSelected = true
        nerRegionImg.image = #imageLiteral(resourceName: "checkmark-1")
        
        
        //hide CR buttons
        subNameButton.isHidden = true
        subNameImg.isHidden = true
        subNameButton.isEnabled = false
        subNameButton.isSelected = false
        subNameImg.image = nil
        
        citButton.isHidden = true
        citImg.isHidden = true
        citButton.isEnabled = false
        citButton.isSelected = false
        citImg.image = nil
        
        dobButton.isHidden = true
        dobImg.isHidden = true
        dobButton.isEnabled = false
        dobButton.isSelected = false
        dobImg.image = nil
        
        regionButton.isHidden = true
        regionImg.isHidden = true
        regionButton.isEnabled = false
        regionButton.isSelected = false
        regionImg.image = nil
        
        vesselButton.isHidden = true
        vesselImg.isHidden = true
        vesselButton.isEnabled = false
        vesselButton.isSelected = false
        vesselImg.image = nil
        
        mitNameButton.isHidden = true
        mitNameImg.isHidden = true
        mitNameButton.isEnabled = false
        mitNameButton.isSelected = false
        mitNameImg.image = nil
        
        reportNumButton.isHidden = true
        reportNumImg.isHidden = true
        reportNumButton.isEnabled = false
        reportNumButton.isSelected = false
        reportNumImg.image = nil
        
    }
    // MAIN VIEW ELEMENTS END
    
    
    /*********NER VIEW ELEMENTS***********/
    
    @IBOutlet weak var nerMainView: UIView!
    
    @IBOutlet weak var nerCategoryBtn: UIButton!
    @IBOutlet weak var nerSubjectBtn: UIButton!
    @IBOutlet weak var nerRegionBtn: UIButton!
    @IBOutlet weak var nerRegionImg: UIImageView!
    @IBOutlet weak var nerSubjectImg: UIImageView!
    @IBOutlet weak var nerCategoryImg: UIImageView!
    /*********NER VIEW ELEMENTS END***********/
    
    var dicToPass = Dictionary<String, Dictionary<String,Any>>()
    var goodToGo:Bool = false
    var pickerData: [String] = [String]()
    let DBRef = DBInt()
    
    override func viewDidLoad() {
        
        self.goodToGo = false
        caseReportsButton.isSelected = true
        nerMainView.isHidden = true
        
        
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
                    let maybe = queryResult as? Dictionary<String,Dictionary<String,Any>>
                    if maybe != nil{
                        for (id,report) in maybe!{
                            self.dicToPass[id] = report
                        }
                    }
                    secondref.observe(.value, with:{ (snapshot:DataSnapshot) in
                        let queryResult2 = snapshot.valueInExportFormat()
                        let maybe2 = queryResult2 as? Dictionary<String,Dictionary<String,Any>>
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
                    var maybe = queryResult as? Dictionary<String,Dictionary<String,Any>>
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
                let maybe = queryResult as? Dictionary<String,Dictionary<String,Any>>
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
                let maybe = queryResult as? Dictionary<String,Dictionary<String,Any>>
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
                let maybe = queryResult as? Dictionary<String,Dictionary<String,Any>>
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
                    let maybe = queryResult as? Dictionary<String,Dictionary<String,Any>>
                    if maybe != nil{
                        for (id,report) in maybe!{
                            self.dicToPass[id] = report
                        }
                    }
                    secondref.observe(.value, with:{ (snapshot:DataSnapshot) in
                        let queryResult2 = snapshot.valueInExportFormat()
                        let maybe2 = queryResult2 as? Dictionary<String,Dictionary<String,Any>>
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
                    var maybe = queryResult as? Dictionary<String,Dictionary<String,Any>>
                    if weBoth == true && maybe != nil{
                        maybe = self.bothStyle(lastToFind: self.subLastField.text!, payload: maybe!)
                    }
                    self.dicToPass = maybe!
                    self.goodToGo = true
                    self.performSegue(withIdentifier: "queryToTable", sender: Any?.self)
                    
                })
            }
        }
        else if reportNumButton.isSelected{
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
                let maybe = queryResult as? Dictionary<String,Dictionary<String,Any>>
                self.dicToPass = maybe!
                self.goodToGo = true
                self.performSegue(withIdentifier: "queryToTable", sender: Any?.self)
                
            })
        }
        else if nerRegionBtn.isSelected{
            let ref: DatabaseReference = Database.database().reference(withPath: "non_emergency_reports")
            
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
                let maybe = queryResult as? Dictionary<String,Dictionary<String,Any>>
                self.dicToPass = maybe!
                self.goodToGo = true
                self.performSegue(withIdentifier: "queryToTable", sender: Any?.self)
                
            })
        }
        else if nerSubjectBtn.isSelected{
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
                    let maybe = queryResult as? Dictionary<String,Dictionary<String,Any>>
                    if maybe != nil{
                        for (id,report) in maybe!{
                            self.dicToPass[id] = report
                        }
                    }
                    secondref.observe(.value, with:{ (snapshot:DataSnapshot) in
                        let queryResult2 = snapshot.valueInExportFormat()
                        let maybe2 = queryResult2 as? Dictionary<String,Dictionary<String,Any>>
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
                    var maybe = queryResult as? Dictionary<String,Dictionary<String,Any>>
                    if weBoth == true && maybe != nil{
                        maybe = self.bothStyle(lastToFind: self.subLastField.text!, payload: maybe!)
                    }
                    self.dicToPass = maybe!
                    self.goodToGo = true
                    self.performSegue(withIdentifier: "queryToTable", sender: Any?.self)
                    
                })
            }
        }
        else if nerCategoryBtn.isSelected{
            let ref: DatabaseReference = Database.database().reference(withPath: "non_emergency_reports")
            
            var newref = DatabaseQuery()
            
            //DETERMINE LIMIT, IF ANY
            var limiter:UInt = 0
            if let limitText = subNameLimitField.text, !limitText.isEmpty{
                limiter = UInt(limitText)!
            }
            
            if limiter == 0{
                if oldestFirstButton.isSelected{
                    newref = ref.queryOrdered(byChild: "category").queryEqual(toValue: ezQueryField.text).queryLimited(toLast:200)
                }
                if newestFirstButton.isSelected{
                    newref = ref.queryOrdered(byChild: "category").queryEqual(toValue: ezQueryField.text!).queryLimited(toLast:200)
                }
            }
            else{
                if oldestFirstButton.isSelected{
                    newref = ref.queryOrdered(byChild: "category").queryEqual(toValue: ezQueryField.text).queryLimited(toLast:limiter)
                }
                if newestFirstButton.isSelected{
                    newref = ref.queryOrdered(byChild: "category").queryEqual(toValue: ezQueryField.text!).queryLimited(toLast:limiter)
                }
            }
            
            
            newref.observe(.value, with:{ (snapshot: DataSnapshot) in
                let queryResult = snapshot.valueInExportFormat()
                print(queryResult!)
                let maybe = queryResult as? Dictionary<String,Dictionary<String,Any>>
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
        if checked == 8{
            nerRegionBtn.isSelected = true
            nerRegionImg.image = #imageLiteral(resourceName: "checkmark-1")
            ezQueryView.isHidden = false
            subNameView.backgroundColor = nerRegionBtn.backgroundColor
            ezQueryTitle.text = "Region Title:"
        }
        else{
            nerRegionImg.image = nil
            nerRegionBtn.isSelected = false
        }
        if checked == 9{
            nerSubjectBtn.isSelected = true
            nerSubjectImg.image = #imageLiteral(resourceName: "checkmark-1")
            ezQueryView.isHidden = true
            subNameView.backgroundColor = nerSubjectBtn.backgroundColor
            subjectFirstNameLabel.text = "Subject First Name:"
            subjectLastNameLabel.text = "Subject Last Name:"
        }
        else{
            nerSubjectImg.image = nil
            nerSubjectBtn.isSelected = false
        }
        
        if checked == 10{
            nerCategoryBtn.isSelected = true
            nerCategoryImg.image = #imageLiteral(resourceName: "checkmark-1")
            ezQueryView.isHidden = false
            subNameView.backgroundColor = nerCategoryBtn.backgroundColor
            ezQueryTitle.text = "Category Title: "
            
        }
        else{
            nerCategoryImg.image = nil
            nerCategoryBtn.isSelected = false
        }
        

    }
    
    func bothStyle(lastToFind:String, payload: Dictionary<String,Dictionary<String,Any>>) -> Dictionary<String,Dictionary<String,Any>>{
        
        var bothFirstAndLast = Dictionary<String,Dictionary<String,Any>>()
        
        for (id,report) in payload{
            if report["perLast"] as! String == lastToFind{
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
    
    //Sending Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //HANDLE EMPTY RESULTS HERE
        if segue.identifier == "queryToTable" {
            let tableViewer = segue.destination as! QueryTableViewController
            tableViewer.passedInDicto = self.dicToPass
            if NERButton.isSelected {
                tableViewer.isCaseReport = false
            }else{
                tableViewer.isCaseReport = true
            }
        }
        else{
            // found nothing
        }
    }
    
}
