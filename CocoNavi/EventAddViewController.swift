//
//  EventAddViewController.swift
//  CocoNavi
//
//  Created by 우원진 on 2020/07/23.
//  Copyright © 2020 WooWonJin. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseAuth

class EventCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
}

class EventPetCell: UICollectionViewCell {
    @IBOutlet weak var petNameLabel: UILabel!
}


extension CALayer {
    func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in arr_edge {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default:
                break
            }
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
}

class EventAddViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextViewDelegate{
    
    var year = ""
    var month = ""
    var day = ""
    var previousDate = ""
    var selectedDate = ""
    let URL = "http://127.0.0.1:8000/"
    var pets : Array<Pet> = []
    var petName = ""
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var titleCollectionView: UICollectionView!
    private var datePicker : UIDatePicker?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var submitBtn: UIButton!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(section == 0){
            return self.pets.count
        }
        else{
            return 5
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.section == 0){
            let cell = titleCollectionView.dequeueReusableCell(withReuseIdentifier: "EventPetCell", for: indexPath) as! EventPetCell
            cell.petNameLabel.translatesAutoresizingMaskIntoConstraints = false
            cell.petNameLabel.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
            cell.petNameLabel.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
            cell.petNameLabel.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 5).isActive = true
            cell.petNameLabel.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -5).isActive = true
            cell.petNameLabel.heightAnchor.constraint(equalToConstant: cell.bounds.height-10).isActive = true
            cell.petNameLabel.widthAnchor.constraint(equalToConstant: cell.bounds.width).isActive = true
            cell.petNameLabel.text = pets[indexPath.row].name
            cell.petNameLabel.textAlignment = .center
            cell.petNameLabel.layer.borderWidth = 0.8
            cell.petNameLabel.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
            cell.petNameLabel.layer.cornerRadius = 5
            print("width : ", cell.bounds.width)
            print("height : ", cell.bounds.height)
            return cell
        }
        else{
            let cell = titleCollectionView.dequeueReusableCell(withReuseIdentifier: "EventCollectionViewCell", for: indexPath) as! EventCollectionViewCell
            cell.titleLabel.translatesAutoresizingMaskIntoConstraints = false
            cell.titleImageView.translatesAutoresizingMaskIntoConstraints = false
            cell.titleLabel.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
            cell.titleLabel.leftAnchor.constraint(equalTo: cell.leftAnchor).isActive = true
            cell.titleLabel.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
            cell.titleLabel.textAlignment = .center
            cell.titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
            cell.titleLabel.widthAnchor.constraint(equalToConstant: cell.bounds.width).isActive = true
            cell.titleImageView.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
            cell.titleImageView.bottomAnchor.constraint(equalTo: cell.titleLabel.topAnchor).isActive = true
            cell.titleImageView.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 10).isActive = true
            cell.titleImageView.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -10).isActive = true
            cell.titleImageView.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
            cell.titleImageView.heightAnchor.constraint(equalToConstant: cell.bounds.height-20).isActive = true
            cell.titleImageView.widthAnchor.constraint(equalToConstant: cell.bounds.width-20).isActive = true
            cell.titleImageView.contentMode = .scaleAspectFit
            var image : UIImage?
            var title : String = ""
            switch indexPath.row {
            case 0:
                image = UIImage(named: "hospital")
                title = "병원"
            case 1:
                image = UIImage(named: "prevention")
                title = "예방접종"
            case 2:
                image = UIImage(named: "feed")
                title = "사료구매"
            case 3:
                image = UIImage(named: "shower")
                title = "목욕"
            case 4:
                image = UIImage(named: "beauty")
                title = "미용"
    //        case 5:
    //            image = UIImage(systemName: "ellipsis")
    //            title = "기타"
            default:
                print("??")
            }
            cell.titleLabel.text = title
            cell.titleImageView.image = image
            if(indexPath.row == 5){
                cell.titleImageView.tintColor = .black
            }

            cell.titleImageView.layer.borderWidth = 0.5
            cell.titleImageView.layer.borderColor = CGColor(srgbRed: 0.5, green: 0.5, blue: 0.5, alpha: 1)
            cell.titleImageView.layer.cornerRadius = (cell.bounds.width-20) / 2
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.section == 0){
//            let cell = titleCollectionView.dequeueReusableCell(withReuseIdentifier: "EventPetCell", for: indexPath) as! EventPetCell
            for index in 0..<self.pets.count{
                let indexP = IndexPath(row: index, section: 0)
                let cell1 = self.titleCollectionView.cellForItem(at: indexP) as! EventPetCell
                cell1.petNameLabel.layer.borderWidth = 0.8
                cell1.petNameLabel.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
            }
            let cell = self.titleCollectionView.cellForItem(at: indexPath) as! EventPetCell
            self.petName = cell.petNameLabel.text!
            cell.petNameLabel.layer.borderWidth = 1.5
            cell.petNameLabel.layer.borderColor = UIColor(red: 251.0/255.0, green: 106.0/255.0, blue: 2.0/255.0, alpha: 1.0).cgColor
            print(self.petName)
        }
        else{
            for index in 0..<5{
                let indexP = IndexPath(row: index, section: 1)
                let cell1 = self.titleCollectionView.cellForItem(at: indexP) as! EventCollectionViewCell
                cell1.titleImageView.layer.borderWidth = 0.5
                cell1.titleImageView.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
            }
            let cell = titleCollectionView.cellForItem(at: indexPath) as! EventCollectionViewCell
            switch(indexPath.row){
            case 0:
                self.titleTextField.text = "병원"
            case 1:
                self.titleTextField.text = "예방접종"
            case 2:
                self.titleTextField.text = "사료구매"
            case 3:
                self.titleTextField.text = "목욕"
            case 4:
                self.titleTextField.text = "미용"
    //        case 5:
    //            self.eventTitle = "기타"
            default:
                print("??")
            }
            cell.titleImageView.layer.borderWidth = 1.5
            cell.titleImageView.layer.borderColor = UIColor(red: 251.0/255.0, green: 106.0/255.0, blue: 2.0/255.0, alpha: 1.0).cgColor
        }
    }
    
    //위아래 라인 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 10
    }
    
    //옆 라인 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(indexPath.section == 0){
            let widthPerItem : CGFloat
            let heightPerItem : CGFloat
            let availableWidth = UIScreen.main.bounds.width
            widthPerItem = availableWidth / 5 - 1
            heightPerItem = widthPerItem / 2
            return CGSize(width: widthPerItem, height: heightPerItem)
        }
        else{
            let widthPerItem : CGFloat
            let heightPerItem : CGFloat
            let availableWidth = UIScreen.main.bounds.width
            widthPerItem = availableWidth / 4 - 1
            heightPerItem = widthPerItem
            return CGSize(width: widthPerItem, height: heightPerItem)
        }
    }
    
    func placeholderSetting() {
            contentTextView.delegate = self // txtvReview가 유저가 선언한 outlet
            contentTextView.text = "내용을 입력하세요."
            contentTextView.textColor = UIColor.lightGray
            
        }
        
        
    // TextView Place Holder
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        
    }
    // TextView Place Holder
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "내용을 입력하세요."
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("pets : " , pets)
        self.datePicker = UIDatePicker()
        datePicker?.locale = NSLocale(localeIdentifier: "ko_KO") as Locale
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(self.dateChanged(datePicker:)), for: .valueChanged)
        
        dateTextField.inputView = datePicker
        dateTextField.text = "\(self.year)-\(self.month)-\(self.day)"
        self.selectedDate = "\(self.year)-\(self.month)-\(self.day)"
        //image 추가
        let imageView = UIImageView()
        let image = UIImage(systemName: "calendar")
        imageView.image = image
        imageView.frame = CGRect(x: 10, y: 0, width: dateTextField.layer.bounds.height, height: dateTextField.layer.bounds.height)
        dateTextField.leftView = imageView
        dateTextField.leftViewMode = .always
        
        //Done Button
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onClickDoneButton))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(onClickCancelButton))
        toolBar.setItems([cancelButton, space, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        dateTextField.inputAccessoryView = toolBar //Change your TextField name here
        //왼쪽으로 슬라이드 하면 뒷 화면
        var leftSwipe : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(slideLeft))
        leftSwipe.direction = .right
        self.view.addGestureRecognizer(leftSwipe)
            
        //collectionView constraints
        self.titleCollectionView.delegate = self
        self.titleCollectionView.dataSource = self
        if(self.pets.count <= 5){
            self.titleCollectionView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 2/3,
                                                             constant: 10).isActive = true
        }
        else{
            self.titleCollectionView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 7/10,
            constant: 10).isActive = true
        }
        self.titleCollectionView.layer.addBorder([.bottom], color: .black, width: 1.0)
//        self.titleCollectionView.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
        
        //titleTextField constraints
        self.titleTextField.translatesAutoresizingMaskIntoConstraints = false
        self.titleTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        self.titleTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        self.titleTextField.topAnchor.constraint(equalTo: self.titleCollectionView.bottomAnchor, constant: 5).isActive = true
        self.titleTextField.widthAnchor.constraint(equalToConstant: self.view.bounds.width-20).isActive = true
        self.titleTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.titleTextField.layer.borderWidth = 0.8
        self.titleTextField.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
        self.titleTextField.layer.cornerRadius = 5
        
        //contentTextView constraints
        self.contentTextView.translatesAutoresizingMaskIntoConstraints = false
        self.contentTextView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        self.contentTextView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        self.contentTextView.topAnchor.constraint(equalTo: self.titleTextField.bottomAnchor, constant: 15).isActive = true
        self.contentTextView.widthAnchor.constraint(equalToConstant: self.view.bounds.width-20).isActive = true
        self.contentTextView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        placeholderSetting()
        self.contentTextView.layer.borderWidth = 0.8
        self.contentTextView.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
        self.contentTextView.layer.cornerRadius = 5
        
        //submitBtn constraints
        self.submitBtn.translatesAutoresizingMaskIntoConstraints = false
        self.submitBtn.leftAnchor.constraint(equalTo:self.view.leftAnchor, constant: 30).isActive = true
        self.submitBtn.rightAnchor.constraint(equalTo:self.view.rightAnchor, constant: -30).isActive = true
        self.submitBtn.topAnchor.constraint(equalTo: self.contentTextView.bottomAnchor, constant: 10).isActive = true
        self.submitBtn.widthAnchor.constraint(equalToConstant: self.view.bounds.width-60).isActive = true
        self.submitBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.submitBtn.layer.cornerRadius = 5
        self.submitBtn.setTitle("등록", for: .normal)
        self.submitBtn.setTitleColor(.white, for: .normal)
        self.submitBtn.backgroundColor = UIColor(red: 251.0/255.0, green: 106.0/255.0, blue: 2.0/255.0, alpha: 1.0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       return UIEdgeInsets(top: 5, left: 0, bottom: 10, right: 0)
    }
    
    @objc func onClickCancelButton(){
        self.dateTextField.text = self.selectedDate
        view.endEditing(true)
    }
    
    @objc func onClickDoneButton(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.dateTextField.text = "\(dateFormatter.string(from: self.datePicker!.date))"
        self.selectedDate = "\(dateFormatter.string(from: self.datePicker!.date))"
        view.endEditing(true)
    }
    
    @objc func viewTapped(gestureReconizer: UIGestureRecognizer){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.dateTextField.text = "\(dateFormatter.string(from: self.datePicker!.date))"
        self.selectedDate = "\(dateFormatter.string(from: self.datePicker!.date))"
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.dateTextField.text = dateFormatter.string(from: datePicker.date)
//        view.endEditing(true)
    }
    
    @objc func slideLeft(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        if(self.petName == ""){
            print("펫을 추가해주세요")
        }
        else if(self.titleTextField.text! == ""){
            print("제목을 입력해주세요")
        }
        else{
            let headers : HTTPHeaders = [ "Accept":"application/json" ,  "Content-Type": "application/json", "X-CSRFToken": "", "charset":"utf-8"]
            let params = ["uid": Auth.auth().currentUser?.uid,
                          "pet_name": self.petName,
                          "title": self.titleTextField.text!,
                          "text": self.contentTextView.text!,
                          "date": self.selectedDate
                          ]
            //info.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            let url = self.URL+"events/add-events/"
            AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                switch(response.result){
                case .success(let value):
                    print(value)
                case .failure(let error):
                    print("Error : Something Wrong")
                }
            }
        }
    }
    
}
