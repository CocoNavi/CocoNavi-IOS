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

class UserInfoCell : UITableViewCell{
    @IBOutlet weak var userAvatar : UIImageView!
    @IBOutlet weak var nicknameLabel : UILabel!
    @IBOutlet weak var emailLabel : UILabel!
}

class PointCell : UITableViewCell{
    @IBOutlet weak var pointLabel : UILabel!
}

class PetCell : UITableViewCell{
    @IBOutlet weak var petCollectionView : UICollectionView!
}

class MyPostCell : UITableViewCell{
    
}

class SavedPostCell : UITableViewCell{
    
}

class MyDiaryCell : UITableViewCell{
    
}

class LogoutCell : UITableViewCell{
    
}

class PetCollectionViewCell : UICollectionViewCell{
    @IBOutlet weak var petAvatar: UIImageView!
    @IBOutlet weak var petNameLabel: UILabel!
}

class PetAddCollectionViewCell : UICollectionViewCell{
    
}

class UserViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pets.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.row < pets.count){
            let cell = self.petCell.petCollectionView.dequeueReusableCell(withReuseIdentifier: "PetCollectionViewCell", for: indexPath) as! PetCollectionViewCell
            cell.petAvatar.layer.cornerRadius = 40
            if(pets[indexPath.row].avatar_url != ""){
                print(pets[indexPath.row].avatar_url)
            }
            if(pets[indexPath.row].kind == "강아지"){
                cell.petAvatar.image = UIImage(named: "dog")
            }
            else if(pets[indexPath.row].kind == "고양이"){
                cell.petAvatar.image = UIImage(named: "cat")
            }
            else{
                print("Something Wrong")
            }
            if(pets[indexPath.row].avatar_url != ""){
                let url = URL(string: "\(self.URL_Site)media/\(pets[indexPath.row].avatar_url)")
                do{
                    let data = try Data(contentsOf: url!)
                    cell.petAvatar.image = UIImage(data: data)
                } catch {
                    print("Error")
                }
            }
            cell.petNameLabel.text = pets[indexPath.row].name
            cell.backgroundColor = UIColor(red: 255/255.0, green: 231/255.0, blue: 148/255.0, alpha: 1.0)
            cell.layer.borderWidth = 0.8
            cell.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
            cell.layer.cornerRadius = 5
            return cell
        }
        else{
            let cell = self.petCell.petCollectionView.dequeueReusableCell(withReuseIdentifier: "PetAddCollectionViewCell", for: indexPath) as! PetAddCollectionViewCell
            cell.layer.borderWidth = 0.8
            cell.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
            cell.layer.cornerRadius = 5
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 110)
    }
    
    //옆 라인 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.row == self.pets.count){
            //펫 추가
            let addPetView = self.storyboard?.instantiateViewController(withIdentifier: "AddPetViewController") as! AddPetViewController
            self.navigationController?.pushViewController(addPetView, animated: true)
        }
        else{
            //펫 정보보기(수정)
            print(indexPath.row)
        }
    }
    
    
    let URL_Site = "http://127.0.0.1:8000/"
    @IBOutlet weak var userInfoCell: UserInfoCell!
    @IBOutlet var userTableView: UITableView!
    @IBOutlet weak var pointCell: PointCell!
    @IBOutlet weak var petCell: PetCell!
    var pets : Array<Pet> = []

    
    func getPets(){
            //유저의 펫정보를 가져온다.
            let headers : HTTPHeaders = [ "Accept":"application/json" ,  "Content-Type": "application/json", "X-CSRFToken": "", "charset":"utf-8"]
            let params = ["uid" : Auth.auth().currentUser?.uid,
                          ]
            //info.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            let url = self.URL_Site+"pets/get-pets/"
            AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                self.pets.removeAll()
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
                        self.pets.insert(Pet(name: name, kind: kind, species: species, birthday: birthday, gender: gender, is_visible: is_visible, avatar_url: avatar_url, profile: profile), at: index)
                    }
                    self.petCell.petCollectionView.reloadData()
                case .failure(let error):
                    print("Something Wrong")
                }
            }
        }
    
    func getUserInfo(){
        let headers : HTTPHeaders = [ "Accept":"application/json" ,  "Content-Type": "application/json", "X-CSRFToken": "", "charset":"utf-8"]
        let params : [String:Any] = ["uid" : Auth.auth().currentUser?.uid]
        //info.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        let url = self.URL_Site+"users/get-user/"
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch(response.result){
            case .success(let value):
                let valueDict = value as! NSDictionary
                let nickname = valueDict.value(forKey: "nickname") as! String
                let email = valueDict.value(forKey: "email") as! String
                let avatar = valueDict.value(forKey: "avatar") as! String
                let point = valueDict.value(forKey: "point") as! Int
                //UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
                self.userInfoCell.nicknameLabel.text = nickname
//                self.userInfoCell.nicknameLabel.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
                self.userInfoCell.emailLabel.text = email
                self.userInfoCell.emailLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
                self.pointCell.pointLabel.text = "\(point)p"
                
                if(avatar != ""){
                    let url = URL(string: "\(self.URL_Site)media/\(avatar)")
                    do{
                        let data = try Data(contentsOf: url!)
                        self.userInfoCell.userAvatar.image = UIImage(data: data)
                    } catch {
                        print("Error")
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0){
            if(indexPath.row == 0){
                print("userInfo")
            }
            else if(indexPath.row == 1){
                print("Point")
            }
            else{
                print("Something Wrong")
            }
        }
        else if(indexPath.section == 1){
            
        }
        else{ //section == 2
            if(indexPath.row == 0){
                print("나의 게시물")
            }
            else if(indexPath.row == 1){
                print("저장한 글")
            }
            else if(indexPath.row == 2){
                print("나의 다이어리")
            }
            else if(indexPath.row == 3){
                print("로그아웃")
            }
            else{
                print("Something Wrong")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPets()
        getUserInfo()
        self.userTableView.delegate = self
        
        //petCollectionView
        self.petCell.petCollectionView.delegate = self
        self.petCell.petCollectionView.dataSource = self
        //userInfoCell
        self.userInfoCell.layer.borderWidth = 0.8
        self.userInfoCell.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
        self.userInfoCell.layer.cornerRadius = 5
        self.userInfoCell.userAvatar.layer.cornerRadius = 40
        self.userInfoCell.userAvatar.tintColor = .white
        self.userInfoCell.userAvatar.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        //
        //Nav Bar title
        self.navigationController?.navigationBar.topItem?.title = ""
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getPets()
        getUserInfo()
    }
    
    @IBAction func logout(_ sender: Any) {
        do{
            try Auth.auth().signOut()
        }catch {
            
        }
        dismiss(animated: true, completion: nil)
    }
    
}
