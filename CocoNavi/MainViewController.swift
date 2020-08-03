//
//  MainViewController.swift
//  CocoNavi
//
//  Created by 우원진 on 2020/07/20.
//  Copyright © 2020 WooWonJin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import Alamofire

class MainViewController: UIViewController {

    @IBOutlet weak var email: UILabel!
    let URL = "http://127.0.0.1:8000/"
    var Pets : Array<Pet> = []
    
    func getPets(){
            //유저의 펫정보를 가져온다.
            let headers : HTTPHeaders = [ "Accept":"application/json" ,  "Content-Type": "application/json", "X-CSRFToken": "", "charset":"utf-8"]
            let params = ["uid" : Auth.auth().currentUser?.uid,
                          ]
            //info.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            let url = self.URL+"pets/get-pets/"
            AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                switch(response.result){
                case .success(let value):
                    let responseList = value as! Array<AnyObject>
                    for (index, _) in responseList.enumerated(){
                        let name = responseList[index]["name"] as! String
                        let kind = responseList[index]["pet_kinds"] as! String
                        var species = ""
    //                    print(responseList[index])
                        if(kind == "강아지"){
                            species = responseList[index]["dog_kind"] as! String
                        }
                        else if(kind == "고양이"){
                            species = responseList[index]["cat_kind"] as! String
                        }
                        else{
                            print("Error : This kind does not exists!")
                        }
                        let birthday = responseList[index]["birthday"] as! String
                        let gender = responseList[index]["gender"] as! String
                        let is_visible = responseList[index]["is_visible"] as! Bool
                        let profile = responseList[index]["profile"] as! String
                        let avatar_url = responseList[index]["pet_avatar"] as! String
                        self.Pets.insert(Pet(name: name, kind: kind, species: species, birthday: birthday, gender: gender, is_visible: is_visible, avatar_url: avatar_url, profile: profile), at: index)
                        
                    }
                    
                case .failure(let error):
                    print("Something Wrong")
                }
            }
        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPets()
        self.email.text = Auth.auth().currentUser?.email
        let username = Auth.auth().currentUser?.email!
        let userUrl = "users/login/google/"
        let headers : HTTPHeaders = [ "Accept":"application/json" ,  "Content-Type": "application/json", "X-CSRFToken": "", "charset":"utf-8"]
        let params = ["username" : Auth.auth().currentUser?.email,
                      "nickname" : Auth.auth().currentUser?.displayName,
                      "uid" : Auth.auth().currentUser?.uid,
                      "login_method" : "google"
                      ]
        let url = URL + userUrl
        //info.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                print(response)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Pets : ", self.Pets)
//        UserDefaults.standard.set(Pets, forKey: "pets_list")
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
