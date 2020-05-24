//
//  PopUpViewController.swift
//  Budgeter
//
//  Created by Vaibhav Sahai on 16/04/2020.
//  Copyright © 2020 Vaibhav Sahai. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var amountEntered: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var itemEntered: UITextField!
    var button = dropDownBtn()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
        self.amountEntered.delegate = self
        self.itemEntered.delegate = self

       
    
        button = dropDownBtn.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        button.setTitle("Click Here To Select Transaction Type", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(button)
        
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        button.widthAnchor.constraint(equalToConstant: 314).isActive = true
        button.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        button.dropView.dropDownOptions = ["Essentials","Luxury","Misc"]
        
    }
    //MARK:- Validation Check
    func validateFields()-> String{
        if amountEntered.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            itemEntered.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""  ||
        button.titleLabel?.text == "Click Here To Select Transaction Type" {
            return "Fail"

        } else{
            return "Success"
        }
            
    }
    
    //MARK:- Transfer Data
    @IBAction func transactionDonePressed(_ sender: Any) {
        if validateFields() == "Success"{
            NotificationCenter.default.post(name: .saveAmountEntered, object: self)
            NotificationCenter.default.post(name: .saveTypeEntered, object: self)
            dismiss(animated: true)
        } else{
            errorLabel.alpha = 1
        }
    }
    
    //MARK:- Transaction Cancelled
    @IBAction func transactionCancelled(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    //MARK:- Hide Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.button.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        amountEntered.resignFirstResponder()
        itemEntered.resignFirstResponder()
        return(true)
    }
    
}
//MARK:- Dropdown Stuff
 
protocol dropDownProtocol{
    func dropDownPressed(string : String)
}

class dropDownBtn: UIButton, dropDownProtocol{
        
    func dropDownPressed(string: String) {
        self.setTitle(string, for: .normal)
        self.dismissDropDown()
    }
    
    var dropView = dropDownView()
    
    var height = NSLayoutConstraint()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.black
        
        dropView = dropDownView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        dropView.delegate = self
        dropView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    override func didMoveToSuperview() {
        
        self.addSubview(dropView)
        self.superview?.addSubview(dropView)
        self.superview?.bringSubviewToFront(dropView)
        
        dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        height = dropView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    var isOpen = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOpen == false{
            
            isOpen = true
            
            NSLayoutConstraint.deactivate([self.height])
            
            if self.dropView.tableView.contentSize.height > 150{
                self.height.constant = 150
                
            }else{
                self.height.constant = self.dropView.tableView.contentSize.height
            }
            
            
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y += self.dropView.frame.height / 2
            }, completion: nil)
            
            
        } else {
            isOpen = false
            
            NSLayoutConstraint.deactivate([self.height])
            self.height.constant = 0
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.center.y -= self.dropView.frame.height / 2
                self.dropView.layoutIfNeeded()
            }, completion: nil)
            
        }
        
    }
    
    func dismissDropDown(){
        isOpen = false
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.dropView.center.y -= self.dropView.frame.height / 2
            self.dropView.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

class dropDownView: UIView, UITableViewDelegate, UITableViewDataSource{
    var typeSelected: String?
    var dropDownOptions = [String]()
    var tableView = UITableView()
    var delegate : dropDownProtocol!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.backgroundColor = UIColor.black
        self.backgroundColor = UIColor.black
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = dropDownOptions[indexPath.row]
        cell.backgroundColor = UIColor.white
        return cell
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.dropDownPressed(string: dropDownOptions[indexPath.row])
        self.tableView.deselectRow(at: indexPath, animated: true)
        
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


