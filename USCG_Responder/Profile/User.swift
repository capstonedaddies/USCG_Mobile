//
//  User.swift
//  USCG_Responder
//
//  Created by Mark Vainauskas on 4/9/19.
//  Copyright © 2019 Patrick Flynn. All rights reserved.
//

import Foundation

struct User {
    var id: String
    var firstName: String
    var lastName: String
    var email: String
    var dob: String
    var address: String
    var vessel: String
    var emContact: String
    var emNumber: String
    var medicalNotes: String
    var lat: String
    var lon: String
    var mayday: String
    var photo: String
    
    init(id: String, firstName: String = "", lastName: String = "", email: String = "", dob: String = "", address: String = "", vessel: String = "", emContact: String = "", emNumber: String = "", medicalNotes: String = "", lat: String = "", lon: String = "", mayday: String = "", photo: String = ""){
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.dob = dob
        self.address = address
        self.vessel = vessel
        self.emContact = emContact
        self.emNumber = emNumber
        self.medicalNotes = medicalNotes
        self.lat = lat
        self.lon = lon
        self.mayday = mayday
        self.photo = photo
        
    }
    
    func toAnyObject() -> Dictionary<String,String>{
        return[
            "id": id,
            "First Name": firstName,
            "Last Name": lastName,
            "Email": email,
            "DOB": dob,
            "Address": address,
            "Vessel No": vessel,
            "Emergency Contact Name": emContact,
            "Emergency Contact Phone": emNumber,
            "Medical Notes": medicalNotes,
            "lat": lat,
            "lon": lon,
            "mayday": mayday,
            "photo": photo
        ]
    }
}

