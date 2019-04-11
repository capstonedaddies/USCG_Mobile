//
//  MapMarkerDelegate.swift
//  USCG_Responder
//
//  Created by Mark Vainauskas on 3/29/19.
//  Copyright © 2019 Patrick Flynn. All rights reserved.
//

import UIKit

protocol MapMarkerDelegate: class {
    func didTapInfoButton(data: NSDictionary)
    
}
class MapMarkerWindow: UIView{
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var lat: UILabel!
    @IBOutlet weak var lon: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    weak var delegate: MapMarkerDelegate?
    var spotData: NSDictionary?
    
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "MapMarkerWindowView", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    }
    
}
