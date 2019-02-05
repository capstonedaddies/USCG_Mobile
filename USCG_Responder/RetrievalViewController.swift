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

class RetrievalViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var dicToPass: Dictionary<String, Dictionary<String,String>>?
    var goodToGo:Bool = false
    var pickerData: [String] = [String]()
    @IBOutlet weak var pickerWheel: UIPickerView!
    @IBOutlet weak var valueField: UITextField!
    @IBOutlet weak var textBox: UITextView!
    let DBRef = DBInt()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    

    override func viewDidLoad() {
        
        self.goodToGo = false
        
        super.viewDidLoad()
        self.pickerWheel.delegate = self
        self.pickerWheel.dataSource = self
        self.pickerData = ["id", "subFirst", "subLast", "region", "timestamp", "vessel", "perFirst", "perLast", "DOB", "citizenship"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ReturnButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "unwindToHomeFromRetrieval", sender: self)
    }
    
    @IBAction func SubmitQuery(_ sender: Any) {
        
        let key = pickerView(pickerWheel, titleForRow: pickerWheel.selectedRow(inComponent: 0), forComponent: 0)
        var ref: DatabaseReference = Database.database().reference(withPath: "case_reports")
        
        if  key == "ID Number"{
            
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
