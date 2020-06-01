//
//  BudgetTab.swift
//  Budgeter
//
//  Created by Vaibhav Sahai on 30/12/2019.
//  Copyright © 2019 Vaibhav Sahai. All rights reserved.
//

import UIKit
import Charts

class BudgetTab: UIViewController {
    
    var currency: String?
    var currentbalance: String?
    var change: String?
    var balanceChecker: Float?
    var type: String?
    var amount: String?
    var startingDate: Date?
    var initialDifference: String?
    let rightNow = Date()
    
    //MARK:- User Defaults Variables
    let defaults = UserDefaults.standard
    struct Keys {
        static let daysLeft = "daysLeft"
        static let balanceLeft = "balanceLeft"
        static let currencySymbol = "currencySymbol"
        static let balance = "balance"
        static let currentBalance = "currentBalance"
        
        //Checking Status Of Existence
        static let balanceExisting = "balanceExisting"
        static let currencyExisting = "currencyExisting"
        //MARK:- Saving Transistion Variables
        static let initialDifference = "initialDifference"
        static let startingdate = "startingDate"
        
    }
    //MARK:- Resetting User Defaults
    @IBAction func goToWelcomePage(_ sender: Any) {
        resetDefaults()
    }
    //MARK:- Popup Pressed
    @IBAction func popupPressed(_ sender: Any) {
        saveUserPreferences()
    }
    //MARK:- CountDown
    lazy var calendar = Calendar.current
    lazy var finalDate = calendar.date(byAdding: .day, value: Int(initialDifference!)!, to: startingDate!)
    
    //MARK:- Chart Variables
    var balanceAmount = PieChartDataEntry(value: 0)
    var balanceTypeLuxury = PieChartDataEntry(value: 0)
    var balanceTypeEssentials = PieChartDataEntry(value: 0)
    var balanceTypeMisc = PieChartDataEntry(value: 0)

    
    var spendingCalculator = [PieChartDataEntry]()
    
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var budgetType: UILabel!
    @IBOutlet weak var currencySymbol: UILabel!
    @IBOutlet weak var balance: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    //MARK:- viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        saveUserPreferences()
        print("Saved Data")
        }
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        checkForUserPreference()
        print("Checked Data")
        dateConfig()
        
        if defaults.bool(forKey: Keys.balanceExisting){
            print("Balance Already Saved And Shown")
        }else{
            balance.text = currentbalance
        }
        
        if defaults.bool(forKey: Keys.currencyExisting){
            print("Currency Already Saved And Shown")
        }else{
            currencySymbol.text = currency
        }
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        print(initialDifference)
        print(startingDate)
        print(finalDate)
        
        balanceAmount.value = Double(balance.text!)!
        balanceAmount.label = "Balance Left"
        
        balanceTypeLuxury.value = Double(0)
        balanceTypeLuxury.label = "On Luxury"
        balanceTypeMisc.value = Double(0)
        balanceTypeMisc.label = "On Misc"
        balanceTypeEssentials.value = Double(0)
        balanceTypeEssentials.label = "On Essentials"
        
        spendingCalculator = [balanceAmount,balanceTypeLuxury,balanceTypeEssentials,balanceTypeMisc]

        balanceChecker = Float(balance.text!)
        status()
        updateChartData()
        

        
        //MARK:- Taking data from popup
        NotificationCenter.default.addObserver(self, selector: #selector(handlePopupClosingAmount), name: .saveAmountEntered, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handlePopupClosingType), name: .saveTypeEntered, object: nil)
        
    }
    
        //MARK:- Taking data prep
    @objc func handlePopupClosingAmount(notification: Notification){
        let amountVC = notification.object as! PopUpViewController
        change = amountVC.amountEntered.text
        
        let initial = Double(balance.text!)
        let deduction = Double(change!)
        let final = Double(initial! - deduction!)
        balance.text = String(final)
        
        if final > -1{
            balanceAmount.value = final
            updateChartData()
        }else{
            balanceAmount.value = 0
            updateChartData()
        }
    
        balanceChecker = Float(balance.text!)
        status()
        
    }
    @objc func handlePopupClosingType(notification: Notification){
        let typeVC = notification.object as! PopUpViewController
        type = typeVC.button.titleLabel!.text
        amount = typeVC.amountEntered!.text
    
        let cost = Double(amount!)
        
        if type == "Essentials"{
            balanceTypeEssentials.value = balanceTypeEssentials.value + cost!
            updateChartData()
        }
        if type == "Luxury"{
            balanceTypeLuxury.value = balanceTypeLuxury.value + cost!
            updateChartData()
        }
        if type == "Misc"{
            balanceTypeMisc.value = balanceTypeMisc.value + cost!
            updateChartData()
        
        }
        
    }

    //MARK:- Chart Updation
    func updateChartData(){
        let chartDataSet = PieChartDataSet(entries: spendingCalculator, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [UIColor.purple, UIColor.red, UIColor.blue, UIColor.lightGray]
    
        chartDataSet.colors = colors
        pieChart.data = chartData
    }
    //MARK:- Status Label
     func status(){
        if balanceChecker! >= 0{
            statusLabel.text = "You're On Track!"
            statusLabel.textColor = UIColor.green
        }else{
            statusLabel.text = "You're Over Budget!"
            statusLabel.textColor = UIColor.red
        }
    }
    //MARK:- Date Config
    func dateConfig() {
        let differenceBetweenDates = calendar.dateComponents([.day], from: rightNow, to: finalDate!).day! + 1
        budgetType.text = String(differenceBetweenDates)
    }
    
    //MARK:- User Defaults
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    func saveUserPreferences(){
        defaults.set(budgetType.text, forKey: Keys.daysLeft)
        defaults.set(balance.text, forKey: Keys.balanceLeft)
        defaults.set(currencySymbol.text, forKey: Keys.currencySymbol)
        
        //MARK:- Saving Transistion Variables
        //The problem is that the value is saved as a nil
        if isKeyPresentInUserDefaults(key: Keys.startingdate){
            print("Starting Date Exists")
        }else{
            defaults.set(startingDate, forKey: Keys.startingdate)
        }
        if isKeyPresentInUserDefaults(key: Keys.initialDifference){
            print("Initial Difference Exists")
        }else{
            defaults.set(initialDifference, forKey: Keys.initialDifference)
        }
        if isKeyPresentInUserDefaults(key: Keys.currentBalance){
            print("Current Balance Variable Exists")
        }else{
            defaults.set(currentbalance, forKey: Keys.currentBalance)
        }
        //Setting Budget Tab As Main Screen
        defaults.set(true, forKey: "IsLoggedIn")
        //Saving Balance
        defaults.set(true, forKey: Keys.balanceExisting)
        //Saving Currency Symbol
        defaults.set(true, forKey: Keys.currencyExisting)
    }
 
    func checkForUserPreference(){
        let daysleft = defaults.string(forKey: Keys.daysLeft)
        budgetType.text = daysleft
        let balanceleft = defaults.string(forKey: Keys.balanceLeft)
        balance.text = balanceleft
        let currencysymbol = defaults.string(forKey: Keys.currencySymbol)
        currencySymbol.text = currencysymbol
        
        //MARK:- Retrieving Transistion Variables
        if isKeyPresentInUserDefaults(key: Keys.startingdate){
            let date = defaults.object(forKey: Keys.startingdate) as! Date
            startingDate = date
        }else{
            print("Starting Date Doesn't Exist")
        }
        
        if isKeyPresentInUserDefaults(key: Keys.initialDifference){
            let initialdifference = defaults.string(forKey: Keys.initialDifference)
            initialDifference = initialdifference
        }else{
            print("Initial Difference Doesn't Exist")
        }
        
        if isKeyPresentInUserDefaults(key: Keys.currentBalance){
            let currentbalance2 = defaults.string(forKey: Keys.currentBalance)
            currentbalance = currentbalance2
        }else{
            print("Current Balance Doesn't Exist")
        }
        
    }
    //MARK:- Reseting Data
    func resetDefaults() {
        print("Reset Defaults: Done")
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
