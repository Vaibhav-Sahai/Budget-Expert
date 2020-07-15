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
    
    var dataForCell = [[String?]]()
    let data = ["1","2","3","4"]
    let sampleData = [["1"],["2"],["3"]]
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //MARK:- Taking Data
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
            let dataToInsert = createArray()
            dataForCell.append(dataToInsert)
            print(dataForCell)
        }
        tableView.reloadData()
        
    }
    //MARK:- Preparing Data Array
    func createArray() -> [String?]{
        var dataUnique = [String?]()
        dataUnique.append(transactionCurrency)
        dataUnique.append(cost)
        dataUnique.append(transactionName)
        dataUnique.append(transactionType)
        dataUnique.append(dateInText)
        
        return dataUnique
    }
    //MARK:- Table View Setup
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataForCell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //MARK:- Customizing Data Output
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TransactionCell
        
        let data = dataForCell[indexPath.row]
        cell.price.text = "Price: "+data[0]!+" "+data[1]!
        cell.itemName.text = "Item Name: "+data[2]!
        cell.type.text = "Type: "+data[3]!
        cell.date.text = data[4]
        
        //Coloring Cell
        if data[3] == "Essentials"{
            cell.itemName.textColor = UIColor.blue
            cell.price.textColor = UIColor.blue
            cell.type.textColor = UIColor.blue
        }
        if data[3] == "Luxury"{
            cell.itemName.textColor = UIColor.red
            cell.price.textColor = UIColor.red
            cell.type.textColor = UIColor.red
        }
        if data[3] == "Misc"{
            cell.itemName.textColor = UIColor.darkGray
            cell.price.textColor = UIColor.darkGray
            cell.type.textColor = UIColor.darkGray
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

