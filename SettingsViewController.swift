//
//  SettingsViewController.swift
//  spmKullan
//
//  Created by beyza nur on 16.10.2023.
//

import UIKit
import Firebase
class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func logOutClicked(_ sender: Any) {
        
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toViewController", sender: nil)

        }catch{
            print("error")
        }
    }
    
    

}
