//
//  PopUpViewController.swift
//  Budgeter
//
//  Created by Vaibhav Sahai on 16/04/2020.
//  Copyright © 2020 Vaibhav Sahai. All rights reserved.
//

import UIKit

protocol dropDownProtocol{
    func dropDownPressed(string : String)
}


class PopUpViewController: UIViewController {
    @IBOutlet weak var amountEntered: UITextField!
    @IBOutlet weak var transactionDone: UIButton!
    @IBOutlet weak var transactionType: UILabel!
    
    var button = dropDownBtn()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button = dropDownBtn.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        button.setTitle("Transaction Type", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(button)
        
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        button.widthAnchor.constraint(equalToConstant: 314).isActive = true
        
        button.dropView.dropDownOptions = ["Essentials","Luxury","Misc"]
        
    }
    //MARK:- Return to budget page
    @IBAction func transactionDonePressed(_ sender: Any) {
        
        dismiss(animated: true)
    }
    
    //MARK:- Dropdown Stuff
    
    class dropDownBtn: UIButton, dropDownProtocol{
        
        func dropDownPressed(string: String) {
            // Fix from here onwards
            self.setTitle(string, for: .normal)
            self.dismissDropDown()
        }
        
        var dropView = dropDownView()
        
        var height = NSLayoutConstraint()
        
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            self.backgroundColor = UIColor.darkGray
            
            dropView = dropDownView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
            dropView.delegate = self
            dropView.translatesAutoresizingMaskIntoConstraints = false
            
        }
        
        override func didMoveToSuperview() {
            
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
        
        var dropDownOptions = [String]()
        var tableView = UITableView()
        var delegate : dropDownProtocol!
        
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            tableView.backgroundColor = UIColor.darkGray
            self.backgroundColor = UIColor.darkGray
            
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
            var cell = UITableViewCell()
            
            cell.textLabel?.text = dropDownOptions[indexPath.row]
            cell.backgroundColor = UIColor.darkGray
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

}
