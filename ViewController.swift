//
//  ViewController.swift
//  spmKullan
//
//  Created by beyza nur on 16.10.2023.
//

import UIKit
import Firebase
//FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    
    //var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //güncel kullanıcı kim alıyoruz
       
        
    }

   
    @IBAction func signInClicked(_ sender: Any) {
        /*
        let feedVC = storyboard?.instantiateViewController(identifier: <#T##String#>) as! FeedViewController
        feedVC.name = name
        navigationController?.pushViewController(feedVC, animated: true)
         */
       //performSegue(withIdentifier: "toFeedVC", sender: nil)
        
        if emailText.text != " " && passwordText.text != " "{
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { authData, error in
                if error != nil{
                    self.makeAlert(title: "Error", message: error!.localizedDescription)
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)

                }
            }
        }else{
            makeAlert(title: "Error", message: "Username/Password")
        }
        
    }
    
    //kaydol
    @IBAction func signUpClicked(_ sender: Any) {
        
        if emailText.text != " " && passwordText.text != " "{
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (authData, error) in
              //Girişte hata olursa
                if error != nil{
                    self.makeAlert(title: "Error", message: error!.localizedDescription)
                
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
          //KULLANICI YERLERİNİ BOŞ BIRAKTIYSA
        }else{
            makeAlert(title: "Error", message: "Kullanıcı adı veya şifre hatalı")
        }
       
    }
    
    func makeAlert(title:String,message:String){
        let alert=UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton=UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okButton)
        self.present(alert,animated: true,completion: nil)
        
    }
}

