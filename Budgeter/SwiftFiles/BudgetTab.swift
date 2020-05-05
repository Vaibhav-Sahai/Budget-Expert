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
    
    var budget: String?
    var currency: String?
    var currentbalance: String?
    var change: String?
    var balanceChecker: Int?
    var type: String?
    var amount: String?
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        budgetType.text = budget
        currencySymbol.text = currency
        balance.text = currentbalance
        
        
        balanceAmount.value = Double(balance.text!)!
        balanceAmount.label = "Balance Left"
        
        balanceTypeLuxury.value = Double(0)
        balanceTypeLuxury.label = "On Luxury"
        balanceTypeMisc.value = Double(0)
        balanceTypeMisc.label = "On Misc"
        balanceTypeEssentials.value = Double(0)
        balanceTypeEssentials.label = "On Essentials"
        
        spendingCalculator = [balanceAmount,balanceTypeLuxury,balanceTypeEssentials,balanceTypeMisc]
        
        balanceChecker = Int(balance.text!)
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

        balanceAmount.value = final
        updateChartData()
        
        balanceChecker = Int(balance.text!)
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
        if balanceChecker ?? -200 >= 0{
            statusLabel.text = "You're On Track!"
            statusLabel.textColor = UIColor.green
        }else{
            statusLabel.text = "You're Over Budget!"
            statusLabel.textColor = UIColor.red
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
