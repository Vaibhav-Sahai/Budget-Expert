//
//  PopUpViewController.swift
//  Budgeter
//
//  Created by Vaibhav Sahai on 16/04/2020.
//  Copyright © 2020 Vaibhav Sahai. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {
    @IBOutlet weak var amountEntered: UITextField!
    
    @IBOutlet weak var transactionDone: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    //MARK:- Return to budget page
    @IBAction func transactionDonePressed(_ sender: Any) {
        
        dismiss(animated: true)
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
