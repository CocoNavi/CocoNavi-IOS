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
import FirebaseUI

class LoginViewController: UIViewController, GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    @IBOutlet weak var googleLoginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self

        Auth.auth().addStateDidChangeListener({(user, error) in
            if Auth.auth().currentUser != nil{
                guard let main = self.storyboard?.instantiateViewController(withIdentifier: "Home") else{
                    return
                }
                //화면 전환 애니메이션을 설정합니다.
                main.modalPresentationStyle = .fullScreen
                main.modalTransitionStyle = UIModalTransitionStyle.coverVertical

                //인자값으로 다음 뷰 컨트롤러를 넣고 present 메소드를 호출합니다.
                self.present(main, animated: true)
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
