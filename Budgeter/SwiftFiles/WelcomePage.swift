//
//  WelcomePage.swift
//  Budgeter
//
//  Created by Vaibhav Sahai on 17/12/2019.
//  Copyright © 2019 Vaibhav Sahai. All rights reserved.
//

import UIKit

class WelcomePage: UIViewController {

    @IBOutlet weak var welcomeButton: UIButton!
    @IBOutlet var WelcomeLabel: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeButton.layer.cornerRadius = 10
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    //MARK:- Return From Budget Tab
    @IBAction func unwindFromNextVC(unwindSegue: UIStoryboardSegue){}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
