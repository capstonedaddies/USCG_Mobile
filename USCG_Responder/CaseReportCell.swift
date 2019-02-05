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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func fillCell(report:Dictionary<String,String>){
        submitterText.text = report["subFirst"]
        perpText.text = report["perpFirst"]
        regionText.text = report["region"]
        timestampText.text = report["timestamp"]
        idText.text = report["id"]
    }
    
}
