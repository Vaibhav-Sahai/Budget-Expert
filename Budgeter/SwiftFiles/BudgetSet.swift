//
//  BudgetSet.swift
//  Budgeter
//
//  Created by Vaibhav Sahai on 28/12/2019.
//  Copyright © 2019 Vaibhav Sahai. All rights reserved.
// performSegue(withIdentifier: "segue", sender: self)

import UIKit
import Foundation

class BudgetSet: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var homeButton: UIButton!
    @IBAction func homeButtonPressed(_ sender: Any) {
        validateFields()
        }

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var budgetText: UITextField!
    @IBOutlet weak var currencySymbol: UILabel!
    @IBOutlet weak var days: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    let rightNow = Date()
    var initialDateDifference: Int?


    //MARK:- Checking Fields
    
    func validateFields(){
        if budgetText.text?.trimmingCharacters(in:  .whitespacesAndNewlines) == "" ||
            currencySymbol.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            days.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            errorLabel.alpha = 1
            
        }else{
            performSegue(withIdentifier: "segue", sender: self)
        }
    }

    //MARK:- Move Screen Up
    @objc func keyboardWillChange(notification: Notification){
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification ||
            notification.name == UIResponder.keyboardWillChangeFrameNotification{
            view.frame.origin.y = -keyboardRect.height + 70
        } else{
            view.frame.origin.y = 0
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
    
    //MARK:- viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        errorLabel.alpha = 0
        budgetText.delegate = self
        days.delegate = self
        
        //Listen for keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    deinit {
        //Stop listening for keyboard
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    
    }
    //MARK: - Hide Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        budgetText.resignFirstResponder()
        days.resignFirstResponder()
        return(true)
    }
    
    // MARK: - Allowed Characters
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = "1234567890"
        let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
        let typedCharacterSet = CharacterSet(charactersIn: string)
        
        return allowedCharacterSet.isSuperset(of: typedCharacterSet)
    }
    //MARK: - Transition
    @IBAction func unwindFromNextVC(unwindSegue: UIStoryboardSegue){}
    
    
    //MARK: - Passing Data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let mainTabBarController = segue.destination as? MainTabBar{
            mainTabBarController.currency = currencySymbol.text
            mainTabBarController.currentbalance = budgetText.text
            mainTabBarController.initialDate = rightNow
            mainTabBarController.initialDifference = days.text
        }
    }
  

}
