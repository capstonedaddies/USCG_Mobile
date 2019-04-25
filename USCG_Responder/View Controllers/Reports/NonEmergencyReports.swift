//
//  NonEmergencyReports.swift
//  USCG_Responder
//
//  Created by Mark Vainauskas on 4/2/19.
//  Copyright © 2019 Patrick Flynn. All rights reserved.
//

import Foundation
struct NonEmergencyReports{
    var id: String
    var subjectFirstName: String
    var subjectLastName: String
    var region: String
    var category:String
    var timestamp: String
    var description:String
    var comment:Dictionary<String,Any>
    
    
    init(id: String, subjectFirstName: String = "", subjectLastName: String = "", region: String = "", category: String = "", timestamp: String = "", description: String = "", comment:Dictionary<String,Any> = [:] ){
        self.id = id
        self.subjectFirstName = subjectFirstName
        self.subjectLastName = subjectLastName
        self.region = region
        self.category = category
        self.timestamp = timestamp
        self.description = description
        self.comment = comment
    }
    
    func toAnyObject() -> Dictionary<String,Any>{
        return[
            "id": id,
            "subjectFirstName": subjectFirstName,
            "subjectLastName": subjectLastName,
            "region": region,
            "category": category,
            "timestamp": timestamp,
            "description": description,
            "comments": comment
        ]
    }
}
