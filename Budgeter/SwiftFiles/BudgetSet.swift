//
//  BudgetSet.swift
//  Budgeter
//
//  Created by Vaibhav Sahai on 28/12/2019.
//  Copyright © 2019 Vaibhav Sahai. All rights reserved.
//

import UIKit

class BudgetSet: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var decider: UISwitch!
    @IBOutlet weak var deciderOutput: UILabel!
    @IBOutlet weak var homeButton: UIButton!
    @IBAction func homeButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var budgetText: UITextField!
    @IBOutlet weak var currencySymbol: UILabel!
    @IBOutlet weak var days: UITextField!
    
    //MARK: - Decider
    
    @IBAction func deciderUsed(_ sender: UISwitch) {
        if (sender.isOn == true){
            deciderOutput.text = "Monthly Budget"
        }
        else{
            deciderOutput.text = "Weekly Budget"
        }
    }
    //MARK: - Picker View Configuration
    let currency = ["S/.", "$", "R$", "৳", "¥", "₹","€", "£","AED"]
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currency[row]
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currency.count
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currencySymbol.text = currency[row]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        budgetText.delegate = self
    }
    //MARK: - Hide Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        budgetText.resignFirstResponder()
        return(true)
    }
    
    // MARK: - TextField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = "123456890"
        let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
        let typedCharacterSet = CharacterSet(charactersIn: string)
        
        return allowedCharacterSet.isSuperset(of: typedCharacterSet)
    }
    //MARK: - Transition
    @IBAction func unwindFromNextVC(unwindSegue: UIStoryboardSegue){}
    
    
    //MARK: - Passing Data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let mainTabBarController = segue.destination as? MainTabBar{
            mainTabBarController.budget = days.text
            mainTabBarController.currency = currencySymbol.text
            mainTabBarController.currentbalance = budgetText.text
        }
    }


}
