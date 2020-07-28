//
//  BudgetTab.swift
//  Budgeter
//
//  Created by Vaibhav Sahai on 30/12/2019.
//  Copyright © 2019 Vaibhav Sahai. All rights reserved.
//

import UIKit
import Charts
import SCLAlertView
import UserNotifications

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
    var count: Double?
    var name: String?
    var transactionDate: Date?
    @IBOutlet weak var resetBudget: UIButton!
    //Setting Up Custom Alerts
    /*let noCloseButton = SCLAlertView.SCLAppearance(
        showCloseButton: false
    )*/
    let alertBudgetReached = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
    
    let alertBudgetNotReached = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
    
    let warnBudget = SCLAlertView()
    
    let checkReset = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
    //MARK:- User Defaults Variables
    let defaults = UserDefaults.standard
    struct Keys {
        static let daysLeft = "daysLeft"
        static let balanceLeft = "balanceLeft"
        static let currencySymbol = "currencySymbol"
        static let balance = "balance"
        static let currentBalance = "currentBalance"
        
        //Saving Piechart Variables
        static let balanceAmount = "balanceAmount"
        static let balanceTypeLuxury = "balanceTypeLuxury"
        static let balanceTypeEssentials = "balanceTypeEssentials"
        static let balanceTypeMisc = "balanceTypeMisc"
        
        //Checking Status Of Existence
        static let balanceExisting = "balanceExisting"
        static let currencyExisting = "currencyExisting"
        static let pieDataExisting = "pieDataExisting"
        //MARK:- Saving Transistion Variables
        static let initialDifference = "initialDifference"
        static let startingdate = "startingDate"
        static let finaldate = "finalDate"
        
        //MARK:- Saving Notifications
        static let fiftyNotification = "fiftyNotification"
        static let seventyFiveNotification = "seventryFiveNotification"
        static let nintyNotification = "nintyNotification"
        static let nintyFiveNotification = "nintyFiveNotification"
    }
    //MARK:- Resetting User Defaults
    @IBAction func goToWelcomePage(_ sender: Any) {
        checkReset.addButton("Yes"){
            self.resetDefaults()
            self.performSegue(withIdentifier: "returnHome", sender: nil)
        }
        checkReset.addButton("No"){
            self.alertBudgetReached.hideView()
        }
        checkReset.showInfo("Confirm Reset", subTitle: "Do You Want To Reset The Budget?")
    }
    
    //MARK:- Notifications
    func notification(x: String){
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert,.sound,.badge]) { (granted, error) in
        }
        let content = UNMutableNotificationContent()
        content.title = "Budget Update!"
        content.body = "You've used "+x+" of your budget!"
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false)
        let request = UNNotificationRequest(identifier: "budgetSpending", content: content, trigger: trigger)
        center.add(request, withCompletionHandler: nil)
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
    
    //MARK:- Custom Alerts
    func budgetAchieved(){
        alertBudgetReached.addButton("Reset"){
            self.resetDefaults()
            self.performSegue(withIdentifier: "returnHome", sender: nil)
        }
        //Horrible Way To Declare Results
        let amountLeft = balance.text!
        alertBudgetReached.showSuccess("Target Reached!", subTitle: "Initial Budget: "+currencySymbol.text!+currentbalance!+"\n Essential Items Spending: "+currencySymbol.text!+String(balanceTypeEssentials.value)+"\n Luxury Items Spending: "+currencySymbol.text!+String(balanceTypeLuxury.value)+"\n Misc. Items Spending: "+currencySymbol.text!+String(balanceTypeMisc.value)+"\n Amount Left: "+currencySymbol.text!+amountLeft)
    }
    
    func budgetNotAchieved(){
        alertBudgetNotReached.addButton("Reset"){
            self.resetDefaults()
            self.performSegue(withIdentifier: "returnHome", sender: nil)
        }
        //Dont Do This
        let amountLeft = balance.text!
        alertBudgetNotReached.showError("Target Not Reached!", subTitle: "Initial Budget: "+currencySymbol.text!+currentbalance!+"\n Essential Items Spending: "+currencySymbol.text!+String(balanceTypeEssentials.value)+"\n Luxury Items Spending: "+currencySymbol.text!+String(balanceTypeLuxury.value)+"\n Misc. Items Spending: "+currencySymbol.text!+String(balanceTypeMisc.value)+"\n Budget Deficit: "+currencySymbol.text!+amountLeft)
    }
    
    func budgetWarnings(x: String){
        let amountLeft = balance.text!
        warnBudget.showWarning("Budget Warning!", subTitle: "You've Used "+x+" Of Your Budget! "+"\n Initial Budget: "+currencySymbol.text!+currentbalance!+"\n Essential Items Spending: "+currencySymbol.text!+String(balanceTypeEssentials.value)+"\n Luxury Items Spending: "+currencySymbol.text!+String(balanceTypeLuxury.value)+"\n Misc. Items Spending: "+currencySymbol.text!+String(balanceTypeMisc.value)+"\n Amount Left: "+currencySymbol.text!+amountLeft)
    }
    
    func checkResults(){
        if Double(budgetType.text!)! < 0.0{
            if Double(balance.text!)! < 0.0{
                budgetNotAchieved()
            }else{
                budgetAchieved()
            }
        }else{
            print("Time Not Over Yet")
        }
    }
    //MARK:- viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dateConfig()
        saveUserPreferences()
        print("Preferences Saved")
        let application = UIApplication.shared
        application.applicationIconBadgeNumber = 0
        
        let tabbar = tabBarController as! MainTabBar
        tabbar.mainCurrencySymbol = currencySymbol.text
    }
    //MARK:- viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        dateConfig()
        saveUserPreferences()
        print("Saved Data")
        let application = UIApplication.shared
        application.applicationIconBadgeNumber = 0
        
        //Notification Stuff
        if isKeyPresentInUserDefaults(key: Keys.fiftyNotification){
            print("50% Notification Already Sent")
        }else{
            if Double(balance.text!)! == Double(currentbalance!)!/2{
                notification(x: "50%")
                budgetWarnings(x: "50%")
                defaults.set(true, forKey: Keys.fiftyNotification)
            }
        }
        
        if isKeyPresentInUserDefaults(key: Keys.seventyFiveNotification){
            print("75% Notification Already Sent")
        }else{
            if Double(balance.text!)! == 0.25 * Double(currentbalance!)!{
                notification(x: "75%")
                budgetWarnings(x: "75%")
                defaults.set(true, forKey: Keys.seventyFiveNotification)
            }
        }
        
        if isKeyPresentInUserDefaults(key: Keys.nintyNotification){
            print("90% Notification Already Sent")
        }else{
            if Double(balance.text!)! == 0.10 * Double(currentbalance!)!{
                notification(x: "90%")
                budgetWarnings(x: "90%")
                defaults.set(true, forKey: Keys.nintyNotification)
            }
        }
        
        if isKeyPresentInUserDefaults(key: Keys.nintyFiveNotification){
            print("95% Notification Already Sent")
        }else{
            if Double(balance.text!)! == 0.05 * Double(currentbalance!)!{
                notification(x: "95%")
                budgetWarnings(x: "95%")
                defaults.set(true, forKey: Keys.nintyFiveNotification)
            }
        }
        }
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        resetBudget.titleLabel!.numberOfLines = 1
        resetBudget.titleLabel!.adjustsFontSizeToFitWidth = true
        resetBudget.titleLabel!.minimumScaleFactor = 0.5
        checkForUserPreference()
        print("Checked Data")
        dateConfig()
        //Sending Data To Popup
        
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
        
        if defaults.bool(forKey: Keys.pieDataExisting){
            print("Pie Data Exists And Shown")
        }else{
            let initialBudget = Double(currentbalance!)!
            balanceAmount.value = Double(balance.text!)!
            balanceAmount.label = "Balance Left"
            
            balanceTypeLuxury.value = Double(0)
            balanceTypeMisc.value = Double(0)
            balanceTypeEssentials.value = Double(0)
            
            
            if balanceTypeLuxury.value > 0.10 * initialBudget || Double(balance.text!)! < 0.90 * initialBudget{
                balanceTypeLuxury.label = "On Luxury"
                balanceTypeMisc.label = "On Misc"
                balanceTypeEssentials.label = "On Essentials"
                
            }else if balanceTypeEssentials.value > 0.10 * initialBudget || Double(balance.text!)! < 0.90 * initialBudget{
                balanceTypeLuxury.label = "On Luxury"
                balanceTypeMisc.label = "On Misc"
                balanceTypeEssentials.label = "On Essentials"
                
            }else if balanceTypeMisc.value > 0.10 * initialBudget || Double(balance.text!)! < 0.90 * initialBudget{
                balanceTypeLuxury.label = "On Luxury"
                balanceTypeMisc.label = "On Misc"
                balanceTypeEssentials.label = "On Essentials"
            }else{
                balanceTypeLuxury.label = ""
                balanceTypeMisc.label = ""
                balanceTypeEssentials.label = ""
            }
            
            //Legend Config
            let legendEntry1 = LegendEntry(label: "On Balance", form: .default, formSize: .nan, formLineWidth: .nan, formLineDashPhase: .nan, formLineDashLengths: .none, formColor: UIColor.purple)
            
            let legendEntry2 = LegendEntry(label: "On Luxury", form: .default, formSize: .nan, formLineWidth: .nan, formLineDashPhase: .nan, formLineDashLengths: .none, formColor: UIColor.red)
            
            let legendEntry3 = LegendEntry(label: "On Essentials", form: .default, formSize: .nan, formLineWidth: .nan, formLineDashPhase: .nan, formLineDashLengths: .none, formColor: UIColor.blue)
            
            let legendEntry4 = LegendEntry(label: "On Misc", form: .default, formSize: .nan, formLineWidth: .nan, formLineDashPhase: .nan, formLineDashLengths: .none, formColor: UIColor.gray)
            
            let legendArray = [legendEntry1,legendEntry2,legendEntry3,legendEntry4]
            
            pieChart.legend.setCustom(entries: legendArray)

            
            spendingCalculator = [balanceAmount,balanceTypeLuxury,balanceTypeEssentials,balanceTypeMisc]
        }

        balanceChecker = Float(balance.text!)
        status()
        updateChartData()
        saveUserPreferences()
        
        //MARK:- Taking data from popup
        NotificationCenter.default.addObserver(self, selector: #selector(handlePopupClosingAmount), name: .saveAmountEntered, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handlePopupClosingType), name: .saveTypeEntered, object: nil)
        checkResults()
        
    }
    
        //MARK:- Taking data prep
    @objc func handlePopupClosingAmount(notification: Notification){
        let amountVC = notification.object as! PopUpViewController
        change = amountVC.amountEntered.text
        
        let initial = Double(balance.text!)
        let deduction = Double(change!)
        let final = Double(initial! - deduction!)
        balance.text = String(format: "%.2f", final)
        
        if final > -1{
            balanceAmount.value = final
            updateChartData()
        }else{
            balanceAmount.value = 0.0
            updateChartData()
        }
    
        balanceChecker = Float(balance.text!)
        status()
        
    }
    
    @objc func handlePopupClosingType(notification: Notification){
        let typeVC = notification.object as! PopUpViewController
        type = typeVC.button.titleLabel!.text
        amount = typeVC.amountEntered!.text
        name = typeVC.itemEntered!.text
        transactionDate = typeVC.dataOfPurchasing
        
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
        let tabbar = tabBarController as! MainTabBar
        tabbar.mainCost = amount
        tabbar.mainTransactionDate = transactionDate
        tabbar.mainTransactionName = name
        tabbar.mainTransactionType = type
        tabbar.mainCurrencySymbol = currencySymbol.text
        tabbar.selectedIndex = 1
    }
    //MARK:- Disabling Transition Variables After View Dissapears
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let tabbar = tabBarController as! MainTabBar
        tabbar.mainCost = "0"
        tabbar.mainTransactionDate = nil
        tabbar.mainTransactionName = "0"
        tabbar.mainTransactionType = "0"
        tabbar.mainCurrencySymbol = "0"
    }
    //MARK:- Chart Updation
    func updateChartData(){
        let chartDataSet = PieChartDataSet(entries: spendingCalculator, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let format = NumberFormatter()
        format.numberStyle = .decimal
        let formatter = DefaultValueFormatter(formatter: format)
        chartData.setValueFormatter(formatter)
        let colors = [UIColor.purple, UIColor.red, UIColor.blue, UIColor.lightGray]
        chartDataSet.colors = colors
        pieChart.data = chartData
        
        let initialBudget = Double(currentbalance!)!
        if balanceTypeLuxury.value > 0.10 * initialBudget || Double(balance.text!)! < 0.90 * initialBudget{
            balanceTypeLuxury.label = "On Luxury"
            balanceTypeMisc.label = "On Misc"
            balanceTypeEssentials.label = "On Essentials"
            
        }else if balanceTypeEssentials.value > 0.10 * initialBudget || Double(balance.text!)! < 0.90 * initialBudget{
            balanceTypeLuxury.label = "On Luxury"
            balanceTypeMisc.label = "On Misc"
            balanceTypeEssentials.label = "On Essentials"
            
        }else if balanceTypeMisc.value > 0.10 * initialBudget || Double(balance.text!)! < 0.90 * initialBudget{
            balanceTypeLuxury.label = "On Luxury"
            balanceTypeMisc.label = "On Misc"
            balanceTypeEssentials.label = "On Essentials"
        }else{
            balanceTypeLuxury.label = ""
            balanceTypeMisc.label = ""
            balanceTypeEssentials.label = ""
        }
        saveUserPreferences()
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
        let differenceBetweenDates = calendar.dateComponents([.day], from: rightNow, to: finalDate!).day!
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
        //Saving Array Of Chart
        defaults.set(balanceAmount.value, forKey: Keys.balanceAmount)
        defaults.set(balanceTypeLuxury.value, forKey: Keys.balanceTypeLuxury)
        defaults.set(balanceTypeMisc.value, forKey: Keys.balanceTypeMisc)
        defaults.set(balanceTypeEssentials.value, forKey: Keys.balanceTypeEssentials)
        
        //MARK:- Saving Transistion Variables
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
        if isKeyPresentInUserDefaults(key: Keys.finaldate){
            print("Final Date Exists")
        }else{
            defaults.set(finalDate, forKey: Keys.finaldate)
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
        //Savin Piechart Data
        defaults.set(true, forKey: Keys.pieDataExisting)
    }
 
    func checkForUserPreference(){
        let daysleft = defaults.string(forKey: Keys.daysLeft)
        budgetType.text = daysleft
        let balanceleft = defaults.string(forKey: Keys.balanceLeft)
        balance.text = balanceleft
        let currencysymbol = defaults.string(forKey: Keys.currencySymbol)
        currencySymbol.text = currencysymbol
        
        //MARK:- Retrieving Piechart Data
        if isKeyPresentInUserDefaults(key: Keys.pieDataExisting){
            let balanceAmountR = defaults.double(forKey: Keys.balanceAmount)
            let balanceTypeMiscR = defaults.double(forKey: Keys.balanceTypeMisc)
            let balanceTypeLuxuryR = defaults.double(forKey: Keys.balanceTypeLuxury)
            let balanceTypeEssentialsR = defaults.double(forKey: Keys.balanceTypeEssentials)
            
            //Assigning Data
            balanceAmount.value = balanceAmountR
            balanceAmount.label = "Balance Left"
            balanceTypeLuxury.value = balanceTypeLuxuryR
            balanceTypeMisc.value = balanceTypeMiscR
            balanceTypeEssentials.value = balanceTypeEssentialsR
            let currentBalanceR = defaults.string(forKey: Keys.currentBalance)
            currentbalance = currentBalanceR
            
            let initialBudget = Double(currentbalance!)!
            if balanceTypeLuxury.value > 0.10 * initialBudget{
                balanceTypeLuxury.label = "On Luxury"
                balanceTypeMisc.label = "On Misc"
                balanceTypeEssentials.label = "On Essentials"
                
            }else if balanceTypeEssentials.value > 0.10 * initialBudget{
                balanceTypeLuxury.label = "On Luxury"
                balanceTypeMisc.label = "On Misc"
                balanceTypeEssentials.label = "On Essentials"
                
            }else if balanceTypeMisc.value > 0.10 * initialBudget{
                balanceTypeLuxury.label = "On Luxury"
                balanceTypeMisc.label = "On Misc"
                balanceTypeEssentials.label = "On Essentials"
            }else{
                balanceTypeLuxury.label = ""
                balanceTypeMisc.label = ""
                balanceTypeEssentials.label = ""
            }
            //Legend Config
            let legendEntry1 = LegendEntry(label: "On Balance", form: .default, formSize: .nan, formLineWidth: .nan, formLineDashPhase: .nan, formLineDashLengths: .none, formColor: UIColor.purple)
            
            let legendEntry2 = LegendEntry(label: "On Luxury", form: .default, formSize: .nan, formLineWidth: .nan, formLineDashPhase: .nan, formLineDashLengths: .none, formColor: UIColor.red)
            
            let legendEntry3 = LegendEntry(label: "On Essentials", form: .default, formSize: .nan, formLineWidth: .nan, formLineDashPhase: .nan, formLineDashLengths: .none, formColor: UIColor.blue)
            
            let legendEntry4 = LegendEntry(label: "On Misc", form: .default, formSize: .nan, formLineWidth: .nan, formLineDashPhase: .nan, formLineDashLengths: .none, formColor: UIColor.gray)
            
            let legendArray = [legendEntry1,legendEntry2,legendEntry3,legendEntry4]
            
            pieChart.legend.setCustom(entries: legendArray)
            
            spendingCalculator = [balanceAmount,balanceTypeLuxury,balanceTypeEssentials,balanceTypeMisc]
        }else{
            print("Pie Data Doesn't Exists")
        }
        
        //MARK:- Retrieving Transistion Variables
        if isKeyPresentInUserDefaults(key: Keys.startingdate){
            let date = defaults.object(forKey: Keys.startingdate) as! Date
            startingDate = date
        }else{
            print("Starting Date Doesn't Exist")
        }
        
        if isKeyPresentInUserDefaults(key: Keys.finaldate){
            let date = defaults.object(forKey: Keys.startingdate) as! Date
            startingDate = date
        }else{
            print("Final Date Doesn't Exist")
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
