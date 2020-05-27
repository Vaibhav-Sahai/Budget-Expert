//
//  MainTabBar.swift
//  Budgeter
//
//  Created by Vaibhav Sahai on 03/01/2020.
//  Copyright © 2020 Vaibhav Sahai. All rights reserved.
//

import UIKit

class MainTabBar: UITabBarController {
    
    var budget: String?
    var currency: String?
    var currentbalance: String?
    var initialDate: Date?
    var initialDifference: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let viewControllers = viewControllers else{
            return
        }
        for viewController in viewControllers{
            if let budgetData = viewController as? BudgetTab{
                budgetData.currency = currency
                budgetData.currentbalance = currentbalance
                budgetData.startingDate = initialDate
                budgetData.initialDifference = initialDifference
                print(initialDifference)
            }
        }
        
}
}
