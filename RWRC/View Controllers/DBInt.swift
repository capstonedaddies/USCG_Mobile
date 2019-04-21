//
//  DBInt.swift
//  USCG_Responder
//
//  Created by Patrick Flynn on 11/28/18.
//  Copyright © 2018 Patrick Flynn. All rights reserved.
//

import Foundation
import Firebase




class DBInt {
    
    // start up that DB, BB
    var crRef: DatabaseReference = Database.database().reference(withPath: "case_reports")
    var nerRef: DatabaseReference = Database.database().reference(withPath: "non_emergency_reports")
    var userRef: DatabaseReference = Database.database().reference(withPath: "user_locations")
    
    init() {
        
    }
    
    func addRecord (record: Dictionary<String, String>){
        let idref = crRef.child(record["id"]!)
        idref.setValue(record)
    }
    
    func addNERRecord(record: Dictionary<String, Any>){
        let idref = nerRef.child(record["id"]! as! String)
        idref.setValue(record)
    }
    
}
