//
//  TransactionLog.swift
//  Budgeter
//
//  Created by Vaibhav Sahai on 14/07/2020.
//  Copyright © 2020 Vaibhav Sahai. All rights reserved.
//

import UIKit

class TransactionLog: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let data = ["1","2","3","4"]
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    //MARK:- Table View Setup
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TransactionCell
        
        cell.itemName.text = data[indexPath.row]
        return cell
    }
    
}
