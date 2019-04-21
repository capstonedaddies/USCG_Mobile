//
//  CaseReport.swift
//  USCG_Responder
//
//  Created by Patrick Flynn on 11/28/18.
//  Copyright © 2018 Patrick Flynn. All rights reserved.
//

import Foundation

struct CaseReport {
    var id: String
    var subFirst: String
    var subLast: String
    var region: String
    var timestampAscending: String
    var timestampDescending: String
    var vessel: String
    var perFirst: String
    var perLast: String
    var DOB: String
    var citizenship: String
    var intLat: String
    var intLon: String
    var notes: String
    var imagePath: String
    
    init(id: String, subFirst: String = "", subLast: String = "", region: String = "", timestampAscending: String = "", timestampDescending: String = "", vessel: String = "", perFirst: String = "", perLast: String = "", DOB: String = "", citizenship: String = "", intLat: String = "", intLon: String = "", notes: String = "", imagePath: String = ""){
        self.id = id
        self.subFirst = subFirst
        self.subLast = subLast
        self.region = region
        self.timestampAscending = timestampAscending
        self.timestampDescending = timestampDescending
        self.vessel = vessel
        self.perFirst = perFirst
        self.perLast = perLast
        self.DOB = DOB
        self.citizenship = citizenship
        self.intLat = intLat
        self.intLon = intLon
        self.notes = notes
        self.imagePath = imagePath
    }
    
    func toAnyObject() -> Dictionary<String,String>{
        return[
        "id": id,
        "subFirst": subFirst,
        "subLast": subLast,
        "region": region,
        "timestampAscending": timestampAscending,
        "timestampDescending": timestampDescending,
        "vessel": vessel,
        "perFirst": perFirst,
        "perLast": perLast,
        "DOB": DOB,
        "citizenship": citizenship,
        "intLat": intLat,
        "intLon": intLon,
        "notes": notes,
        "imagePath": imagePath
        ]
    }
    
}
