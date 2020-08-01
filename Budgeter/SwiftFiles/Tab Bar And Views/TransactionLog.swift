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
    @IBOutlet weak var informationLabel: UILabel!
    
    let defaults = UserDefaults.standard
    var dataForCell = [[String?]]()
    var count: Int = 0
    struct Keys{
        static let dataToSave = "dataToSave"
        static let saveState = "saveState"
    }
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if defaults.bool(forKey: Keys.saveState){
            checkUserPreferences()
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        tableView.reloadData()
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
            let dataToInsert = createArray()

            dataForCell.append(dataToInsert)
            saveUserPreferences()
           
        tableView.reloadData()
        }
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
        if dataForCell.count == 0{
            informationLabel.text = "Your Transactions Will Show Here"
        }
        if dataForCell.count > 0{
            informationLabel.text = "Swipe Left On Cells To Delete Them"
        }
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
    //Deleting Cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            dataForCell.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .top)
            saveUserPreferences()
        }
    }
    
    
    func saveUserPreferences(){
        defaults.set(dataForCell, forKey: Keys.dataToSave)
        defaults.set(true, forKey: Keys.saveState)
    }
    func checkUserPreferences(){
        let tempArray = defaults.array(forKey: Keys.dataToSave) as? [[String?]]
        dataForCell = tempArray!
    }
}

