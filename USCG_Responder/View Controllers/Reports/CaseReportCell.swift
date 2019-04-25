//
//  Cell.swift
//  USCG_Responder
//
//  Created by Patrick Flynn on 1/25/19.
//  Copyright © 2019 Patrick Flynn. All rights reserved.
//

import Foundation
import UIKit

class CaseReportCell:UITableViewCell{
    
    @IBOutlet weak var submitterText: UILabel!
    @IBOutlet weak var perpText: UILabel!
    @IBOutlet weak var regionText: UILabel!
    @IBOutlet weak var timestampText: UILabel!
    @IBOutlet weak var idText: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func fillCell(report:Dictionary<String,Any>, isCaseReport:Bool){
        if isCaseReport{
            submitterText.text = (report["subFirst"] as! String)
            perpText.text = (report["perFirst"] as! String)
            regionText.text = (report["region"] as! String)
            timestampText.text = "FIX ME PLS"
            idText.text = (report["id"] as! String)
        }else{
            submitterText.text = (report["subjectFirstName"] as! String)
            perpText.text = (report["subjectLastName"] as! String)
            regionText.text = (report["region"] as! String)
            timestampText.text = (report["timestamp"] as! String)
            idText.text = (report["id"] as! String)
            
            
        }
    }
    
}
