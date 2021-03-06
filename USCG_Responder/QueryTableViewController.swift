//
//  QueryTableViewController.swift
//  USCG_Responder
//
//  Created by Patrick Flynn on 1/25/19.
//  Copyright © 2019 Patrick Flynn. All rights reserved.
//

import UIKit

class QueryTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var numResultsText: UINavigationItem!
    
    var passedInDicto: Dictionary<String, Dictionary<String,String>>?
    var appendInto: [Dictionary<String,String>] = []
    var selectedRow:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectedRow = 0
        
        numResultsText.title = "Displaying \(String(describing: passedInDicto?.count)) results."
        
        for (_,y) in passedInDicto!{
            appendInto.append(y)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var queryList:Array<Any> = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appendInto.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CaseReportCell", for: indexPath) as! CaseReportCell
        cell.fillCell(report:appendInto[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row
        self.performSegue(withIdentifier: "cellToEditor", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cellToEditor"{
            let destination = segue.destination as! EditorViewController
            destination.mainDic = self.appendInto[self.selectedRow]
        }
    }
    
    @IBAction func unwindToQueryTable(_ sender: UIStoryboardSegue){
        
    }
}
