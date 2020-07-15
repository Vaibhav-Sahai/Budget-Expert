//
//  TransactionLog.swift
//  Budgeter
//
//  Created by Vaibhav Sahai on 14/07/2020.
//  Copyright © 2020 Vaibhav Sahai. All rights reserved.
//

import UIKit

class TransactionLog: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var cost: String?
    var transactionName: String?
    var transactionType: String?
    var transactionDate: Date?
    var transactionCurrency: String?
    var dateInText: String?
    
    var dataForCell: [String?] = []
    let data = ["1","2","3","4"]
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = tabBarController as! MainTabBar
        cost = tabbar.mainCost
        transactionName = tabbar.mainTransactionName
        transactionType = tabbar.mainTransactionType
        transactionDate = tabbar.mainTransactionDate
        transactionCurrency = tabbar.mainCurrencySymbol
        /*print(cost)
        print(transactionType)
        print(transactionName)
        print(transactionDate)*/
        
        if transactionDate != nil{
            let formatter = DateFormatter()
            formatter.locale = .current
            formatter.timeZone = .current
            formatter.dateFormat = "MMM d, h:mm a"
            
            dateInText = formatter.string(from: transactionDate!)
            //print(dateInText)
            dataForCell.append(contentsOf: createArray())
            print(dataForCell)
        }
    }
    //MARK:- Preparing Data Array
    func createArray() -> [String?]{
        var dataUnique: [String?] = []
        dataUnique.append(transactionCurrency)
        dataUnique.append(cost)
        dataUnique.append(transactionName)
        dataUnique.append(transactionType)
        dataUnique.append(dateInText)
        
        return dataUnique
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
