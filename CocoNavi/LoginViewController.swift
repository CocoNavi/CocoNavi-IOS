//
//  LoginViewController.swift
//  CocoNavi
//
//  Created by 우원진 on 2020/07/20.
//  Copyright © 2020 WooWonJin. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth

class LoginViewController: UIViewController, GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    

    @IBOutlet weak var googleLoginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
//        if Auth.auth().currentUser != nil{
//            self.performSegue(withIdentifier: "Home", sender: nil)
//        }
        Auth.auth().addStateDidChangeListener({(user, error) in
            if Auth.auth().currentUser != nil{
                self.performSegue(withIdentifier: "Home", sender: nil)
            }
            else{

            }
        })
    }

    @IBAction func googleLoginTapped(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func didTapSignOut(_ sender: AnyObject) {
      GIDSignIn.sharedInstance().signOut()
    }
}
