//
//  UserViewController.swift
//  CocoNavi
//
//  Created by 우원진 on 2020/07/20.
//  Copyright © 2020 WooWonJin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import Alamofire

class UserViewController: UIViewController {

    let URL = "http://127.0.0.1:8000/"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logout(_ sender: Any) {
        do{
            try Auth.auth().signOut()
        }catch {
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPet(_ sender: Any) {
        let headers : HTTPHeaders = [ "Accept":"application/json" ,  "Content-Type": "application/json", "X-CSRFToken": "", "charset":"utf-8"]
        let params : [String:Any] = ["uid" : Auth.auth().currentUser?.uid,
                      "name" : "우누리",
                      "kind" : "강아지",
                      "species" : "말티즈",
                      "birthday" : "2019-05-08",
                      "gender" : "MALE",
                      "is_visible" : true,
                      "avatar" : "",
                      "profile" : "우누리이"]
        //info.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        let url = self.URL+"pets/add-pets/"
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch(response.result){
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error)
            }
        }
    }
}
