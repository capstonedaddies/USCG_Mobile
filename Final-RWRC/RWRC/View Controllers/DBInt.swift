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
    var ref: DatabaseReference = Database.database().reference(withPath: "case_reports")
    
    init() {
        
    }
    
    func addRecord (record: Dictionary<String, String>){
        let idref = ref.child(record["id"]!)
        idref.setValue(record)
    }
    
}
