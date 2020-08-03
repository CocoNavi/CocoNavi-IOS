//
//  EventAddViewController.swift
//  CocoNavi
//
//  Created by 우원진 on 2020/07/23.
//  Copyright © 2020 WooWonJin. All rights reserved.
//

import UIKit
import Alamofire

class EventCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
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
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var titleCollectionView: UICollectionView!
    private var datePicker : UIDatePicker?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 2
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = titleCollectionView.dequeueReusableCell(withReuseIdentifier: "EventCollectionViewCell", for: indexPath) as! EventCollectionViewCell
        cell.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.titleImageView.translatesAutoresizingMaskIntoConstraints = false
        cell.titleLabel.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
        cell.titleLabel.leftAnchor.constraint(equalTo: cell.leftAnchor).isActive = true
        cell.titleLabel.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
        cell.titleLabel.textAlignment = .center
        cell.titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        cell.titleLabel.widthAnchor.constraint(equalToConstant: cell.bounds.width).isActive = true
        cell.titleImageView.translatesAutoresizingMaskIntoConstraints = false
        cell.titleImageView.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        cell.titleImageView.bottomAnchor.constraint(equalTo: cell.titleLabel.topAnchor).isActive = true
        cell.titleImageView.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 10).isActive = true
        cell.titleImageView.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -10).isActive = true
        cell.titleImageView.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        cell.titleImageView.heightAnchor.constraint(equalToConstant: cell.bounds.height-20).isActive = true
        cell.titleImageView.widthAnchor.constraint(equalToConstant: cell.bounds.width-20).isActive = true
        cell.titleImageView.contentMode = .scaleAspectFit
//        print("cell height : ", cell.bounds.height)
//        print("cell width : ", cell.bounds.width)
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

//        print("label height : ", cell.titleLabel.bounds.height)
//        print("label width : ", cell.titleLabel.bounds.width)
//        print("image height : ", cell.titleImageView.bounds.height)
//        print("image width : ", cell.titleImageView.bounds.width)
        cell.titleImageView.layer.borderWidth = 0
//        cell.titleImageView.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        cell.titleImageView.layer.cornerRadius = (cell.bounds.width-20) / 2
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = titleCollectionView.dequeueReusableCell(withReuseIdentifier: "EventCollectionViewCell", for: indexPath) as! EventCollectionViewCell
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
        let widthPerItem : CGFloat
        let heightPerItem : CGFloat
        let availableWidth = UIScreen.main.bounds.width
        widthPerItem = availableWidth / 4 - 1
        heightPerItem = widthPerItem
        return CGSize(width: widthPerItem, height: heightPerItem)
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
        self.titleCollectionView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/2, constant: 10).isActive = true
        self.titleCollectionView.layer.addBorder([.bottom], color: .black, width: 1.0)
//        self.titleCollectionView.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
        
        //titleTextField constraints
        self.titleTextField.translatesAutoresizingMaskIntoConstraints = false
        self.titleTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        self.titleTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        self.titleTextField.topAnchor.constraint(equalTo: self.titleCollectionView.bottomAnchor, constant: 10).isActive = true
        self.titleTextField.widthAnchor.constraint(equalToConstant: self.view.bounds.width-20).isActive = true
        self.titleTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.titleTextField.layer.borderWidth = 0.8
        self.titleTextField.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
        self.titleTextField.layer.cornerRadius = 5
        
        //contentTextView constraints
        self.contentTextView.translatesAutoresizingMaskIntoConstraints = false
        self.contentTextView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        self.contentTextView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        self.contentTextView.topAnchor.constraint(equalTo: self.titleTextField.bottomAnchor, constant: 15).isActive = true
        self.contentTextView.widthAnchor.constraint(equalToConstant: self.view.bounds.width-20).isActive = true
        self.contentTextView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        placeholderSetting()
        self.contentTextView.layer.borderWidth = 0.8
        self.contentTextView.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
        self.contentTextView.layer.cornerRadius = 5
        
        print("Pet in Event",self.pets)
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
    
    
    

}
