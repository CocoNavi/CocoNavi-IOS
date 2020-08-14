//
//  AddPetViewController.swift
//  CocoNavi
//
//  Created by 우원진 on 2020/08/07.
//  Copyright © 2020 WooWonJin. All rights reserved.
//

import UIKit
import FirebaseAuth
import Alamofire

class PetSpeciesCell: UICollectionViewCell{
    @IBOutlet weak var speciesName : UILabel!
}

class AddPetViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextViewDelegate {
    
    @IBOutlet weak var addPetAvatarBtn: UIButton!
    let imagePickerController = UIImagePickerController()
    @IBOutlet weak var petName: UITextField!
    @IBOutlet weak var dogBtn: UIButton!
    @IBOutlet weak var catBtn: UIButton!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var birthdayTextField: UITextField!
    private var birthdayPicker : UIDatePicker?
    @IBOutlet weak var petProfileTextView: UITextView!
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet weak var petSpeciesCollectionView: UICollectionView!
    
    let URL = "http://127.0.0.1:8000/"
    var petKind = "강아지"
    var petGender = ""
    var petSpecies = ""
    var selectedDate = ""
    var year = ""
    var month = ""
    var day = ""
    var pk = ""
    
    let dogBreeds : Array<String> = ["말티즈","푸들","포메라니안","시츄","비숑","요크셔테리어","치와와","스피츠","닥스훈트","진도견","웰시코기","시바견","믹스","기타"]
    let catBreeds : Array<String> = ["코숏","스코티쉬폴드","러시안블루","아메숏","먼치킨","페르시안",  "샴","뱅갈","브리티쉬숏헤어","터키쉬앙고라","아비시니안","믹스","기타"]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(self.petKind == "강아지"){
            return dogBreeds.count
        }
        else if(self.petKind == "고양이"){
            return catBreeds.count
        }
        else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.petSpeciesCollectionView.dequeueReusableCell(withReuseIdentifier: "PetSpeciesCell", for: indexPath) as! PetSpeciesCell
        cell.speciesName.translatesAutoresizingMaskIntoConstraints = false
        cell.speciesName.leftAnchor.constraint(equalTo: cell.leftAnchor).isActive = true
        cell.speciesName.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
        cell.speciesName.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        cell.speciesName.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
        cell.speciesName.widthAnchor.constraint(equalTo: cell.widthAnchor).isActive = true
        cell.speciesName.heightAnchor.constraint(equalTo: cell.heightAnchor).isActive = true
        if(self.petKind == "강아지"){
            cell.speciesName.text = self.dogBreeds[indexPath.row]
        }
        else if(self.petKind == "고양이"){
            cell.speciesName.text = self.catBreeds[indexPath.row]
        }
        else{
            print("Error")
        }
        cell.speciesName.textAlignment = .center
        cell.speciesName.layer.borderWidth = 0.8
        cell.speciesName.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
        cell.speciesName.layer.cornerRadius = 5
//        cell.speciesName.font = UIFont(name: "system", size: 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = self.petSpeciesCollectionView.bounds.height / 4
        var numberOfRow = 0
        if(self.petKind == "강아지"){
            numberOfRow = 4
        }
        else if(self.petKind == "고양이"){
            numberOfRow = 4
        }
        else{
            return CGSize(width: 0, height: 0)
        }
        let width = self.petSpeciesCollectionView.bounds.width / CGFloat(numberOfRow)
        return CGSize(width: width-2, height: height-2)
    }
    
    //위아래 라인 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 2
    }
    
    //옆 라인 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var count = 0
        if(self.petKind == "강아지"){
            count = self.dogBreeds.count
        }
        else if(self.petKind == "고양이"){
            count = self.catBreeds.count
        }
        else{
            print("error")
        }
        
        for index in 0..<count{
            let indexP = IndexPath(row: index, section: 0)
            let cell1 = self.petSpeciesCollectionView.cellForItem(at: indexP) as! PetSpeciesCell
            cell1.speciesName.layer.borderWidth = 0.8
            cell1.speciesName.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
        }
        let cell = self.petSpeciesCollectionView.cellForItem(at: indexPath) as! PetSpeciesCell
        self.petSpecies = cell.speciesName.text!
        cell.speciesName.layer.borderWidth = 1.5
        cell.speciesName.layer.borderColor = UIColor(red: 251.0/255.0, green: 106.0/255.0, blue: 2.0/255.0, alpha: 1.0).cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.birthdayPicker = UIDatePicker()
        birthdayPicker?.locale = NSLocale(localeIdentifier: "ko_KO") as Locale
        birthdayPicker?.datePickerMode = .date
        birthdayPicker?.addTarget(self, action: #selector(self.dateChanged(datePicker:)), for: .valueChanged)
        
        birthdayTextField.inputView = birthdayPicker
        birthdayTextField.text = "\(self.year)-\(self.month)-\(self.day)"
        self.selectedDate = "\(self.year)-\(self.month)-\(self.day)"
        //image 추가
        let imageView = UIImageView()
        let image = UIImage(systemName: "calendar")
        imageView.image = image
        imageView.frame = CGRect(x: 10, y: 0, width: birthdayTextField.layer.bounds.height, height: birthdayTextField.layer.bounds.height)
        birthdayTextField.leftView = imageView
        birthdayTextField.leftViewMode = .always
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onClickDoneButton))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(onClickCancelButton))
        toolBar.setItems([cancelButton, space, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        birthdayTextField.inputAccessoryView = toolBar //Change your TextField name here
        
        imagePickerController.delegate = self
        self.addPetAvatarBtn.layer.cornerRadius = 40
        self.addPetAvatarBtn.layer.masksToBounds = true
        
//        self.dogBtn.layer.borderWidth = 0.8
//        self.dogBtn.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
        self.dogBtn.layer.borderWidth = 1.3
        self.dogBtn.layer.borderColor = UIColor(red: 251.0/255.0, green: 106.0/255.0, blue: 2.0/255.0, alpha: 1.0).cgColor
        self.dogBtn.layer.cornerRadius = 5
        self.dogBtn.layer.masksToBounds = true
        
        self.catBtn.layer.borderWidth = 0.8
        self.catBtn.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
        self.catBtn.layer.cornerRadius = 5
        self.catBtn.layer.masksToBounds = true
        
        self.maleBtn.layer.borderWidth = 0.8
        self.maleBtn.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
        self.maleBtn.layer.cornerRadius = 5
        self.maleBtn.layer.masksToBounds = true
        
        self.femaleBtn.layer.borderWidth = 0.8
        self.femaleBtn.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
        self.femaleBtn.layer.cornerRadius = 5
        self.femaleBtn.layer.masksToBounds = true
        
        self.petSpeciesCollectionView.delegate = self
        self.petSpeciesCollectionView.dataSource = self
        
        //submit Btn
        self.submitBtn.translatesAutoresizingMaskIntoConstraints = false
        self.submitBtn.backgroundColor = UIColor(red: 251.0/255.0, green: 106.0/255.0, blue: 2.0/255.0, alpha: 1.0)
        self.submitBtn.layer.cornerRadius = 5
        
        //petProfileTextView
        self.petProfileTextView.translatesAutoresizingMaskIntoConstraints = false
        self.petProfileTextView.layer.borderWidth = 0.8
        self.petProfileTextView.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
        self.petProfileTextView.layer.cornerRadius = 5
        self.petProfileTextView.delegate = self
        self.placeholderSetting()
    }

    func placeholderSetting() {
            petProfileTextView.delegate = self // txtvReview가 유저가 선언한 outlet
            if(self.pk == ""){
                petProfileTextView.text = "펫 소개를 해주세요."
                petProfileTextView.textColor = UIColor.lightGray
            }
        }
    
        
    // TextView Place Holder
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.textColor == UIColor.lightGray && self.pk == "") {
            textView.text = nil
            textView.textColor = UIColor.black
            textView.layer.borderColor = UIColor(red: 251.0/255.0, green: 106.0/255.0, blue: 2.0/255.0, alpha: 1.0).cgColor
        }
        
    }
    
    // TextView Place Holder
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text.isEmpty && self.pk == "") {
            textView.text = "펫 소개를 해주세요."
            textView.textColor = UIColor.lightGray
        }
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.birthdayTextField.text = dateFormatter.string(from: datePicker.date)
    //        view.endEditing(true)
    }
    
    @objc func onClickCancelButton(){
        self.birthdayTextField.text = self.selectedDate
        view.endEditing(true)
    }
    
    @objc func onClickDoneButton(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.birthdayTextField.text = "\(dateFormatter.string(from: self.birthdayPicker!.date))"
        self.selectedDate = "\(dateFormatter.string(from: self.birthdayPicker!.date))"
        view.endEditing(true)
    }
    
    @objc func viewTapped(gestureReconizer: UIGestureRecognizer){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.birthdayTextField.text = "\(dateFormatter.string(from: self.birthdayPicker!.date))"
        self.selectedDate = "\(dateFormatter.string(from: self.birthdayPicker!.date))"
        view.endEditing(true)
    }
    
    @IBAction func addPetAvatar(_ sender: Any) {
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            self.addPetAvatarBtn.setImage(image, for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dogBtnTapped(_ sender: Any) {
        self.petKind = "강아지"
        self.dogBtn.layer.borderWidth = 1.3
        self.dogBtn.layer.borderColor = UIColor(red: 251.0/255.0, green: 106.0/255.0, blue: 2.0/255.0, alpha: 1.0).cgColor
        self.catBtn.layer.borderWidth = 0.8
        self.catBtn.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
        self.petSpeciesCollectionView.reloadData()
    }
    
    @IBAction func catBtnTapped(_ sender: Any) {
        self.petKind = "고양이"
        self.dogBtn.layer.borderWidth = 0.8
        self.catBtn.layer.borderWidth = 1.3
        self.catBtn.layer.borderColor = UIColor(red: 251.0/255.0, green: 106.0/255.0, blue: 2.0/255.0, alpha: 1.0).cgColor
        self.dogBtn.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
        self.petSpeciesCollectionView.reloadData()
    }
    
    @IBAction func maleBtnTapped(_ sender: Any) {
        self.petGender = "MALE"
        self.femaleBtn.layer.borderWidth = 0.8
        self.maleBtn.layer.borderWidth = 1.3
        self.maleBtn.layer.borderColor = UIColor(red: 251.0/255.0, green: 106.0/255.0, blue: 2.0/255.0, alpha: 1.0).cgColor
        self.femaleBtn.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
    }
    
    @IBAction func femaleBtnTapped(_ sender: Any) {
        self.petGender = "FEMALE"
        self.maleBtn.layer.borderWidth = 0.8
        self.femaleBtn.layer.borderWidth = 1.3
        self.femaleBtn.layer.borderColor = UIColor(red: 251.0/255.0, green: 106.0/255.0, blue: 2.0/255.0, alpha: 1.0).cgColor
        self.maleBtn.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
    }
    
    @IBAction func addPetBtnTapped(_ sender: Any) {
        let headers : HTTPHeaders = [ "Accept":"application/json" ,  "Content-Type": "application/json", "X-CSRFToken": "", "charset":"utf-8"]
        let params : [String:Any] = ["uid" : Auth.auth().currentUser?.uid,
                                     "name" : self.petName.text!,
                                     "kind" : self.petKind,
                                     "species" : self.petSpecies,
                                     "birthday" : self.birthdayTextField.text!,
                                     "gender" : self.petGender,
                      "is_visible" : true,
                      "avatar" : "",
                      "profile" : self.petProfileTextView.text!]
        print("parameter : ", params)
        //info.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
//        let url = self.URL+"pets/add-pets/"
//        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
//            switch(response.result){
//            case .success(let value):
//                print(value)
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
}
