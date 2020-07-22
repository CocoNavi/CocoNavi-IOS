//
//  CalendarViewController.swift
//  CocoNavi
//
//  Created by 우원진 on 2020/07/20.
//  Copyright © 2020 WooWonJin. All rights reserved.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    @IBOutlet weak var dateLabel: UILabel!
}

class CalendarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var CalendarCollectionView: UICollectionView!
    
    var dateAtIndex = [String](repeating: "", count: 42)
    var numOfDaysInMonth : [Int] = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    var currentYear : Int = -1
    var currentMonth : Int = -1
    var todayDate : Int = -1
    var firstDay : Int = -1
    
    func getDayOfWeek(_ today:String) -> Int? {
        let formatter  = DateFormatter()    // 1
        formatter.dateFormat = "yyyy-MM-dd" // 2
        guard let todayDate = formatter.date(from: today) else { return nil }  // 3
        let myCalendar = Calendar(identifier: .gregorian)   // 4
        let weekDay = myCalendar.component(.weekday, from: todayDate) // 5
        return weekDay
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentYear = Calendar.current.component(.year, from: Date())
        self.currentMonth = Calendar.current.component(.month, from: Date())
        self.todayDate = Calendar.current.component(.day, from: Date())
        self.firstDay = self.getDayOfWeek("\(self.currentYear)-\(self.currentMonth)-01")!
        if(currentYear % 4 == 0){
            numOfDaysInMonth[1] = 29
        }
        else{
            numOfDaysInMonth[1] = 28
        }
        self.leftBtn.tintColor = .black
        self.rightBtn.tintColor = .black
        self.CalendarCollectionView.delegate = self
        self.CalendarCollectionView.dataSource = self
//        self.CalendarCollectionView.reloadData()
        self.yearLabel.text = "\(self.currentYear)"
        self.monthLabel.text = "\(self.currentMonth)월"
        
        //swipe
        var rightSwipe : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(slideRight))
        rightSwipe.direction = .left
        var leftSwipe : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(slideLeft))
        leftSwipe.direction = .right
        self.CalendarCollectionView.addGestureRecognizer(rightSwipe)
        self.CalendarCollectionView.addGestureRecognizer(leftSwipe)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //캘린더 셀마다
//        let cell = CalendarCollectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        if(indexPath.row < 7){
            print("Nothing happen : Day")
        }
        else if(indexPath.row-6 < self.firstDay){
            print("Nothing happen : previous month")
        }
        else if(indexPath.row >= 6+firstDay+self.numOfDaysInMonth[self.currentMonth-1]){
            print("Nothing happen : next month")
        }
        else{
            print("tapped")
            let date = "\(self.currentYear)-\(self.currentMonth)-\(self.dateAtIndex[indexPath.row-7])"
            print(date)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 49
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = CalendarCollectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        cell.dateLabel.translatesAutoresizingMaskIntoConstraints = true
//        cell.dateLabel.topAnchor.constraint(equalTo: cell.topAnchor, constant: 0)
//        cell.dateLabel.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 0)
//        cell.dateLabel.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: 0)
        cell.dateLabel.frame = CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.width/2)
        if(indexPath.row < 7){
            switch(indexPath.row){
                case 0:
                    cell.dateLabel.text = "일"
                    cell.dateLabel.textColor = .red
                case 1:
                    cell.dateLabel.text = "월"
                    cell.dateLabel.textColor = .black
                case 2:
                    cell.dateLabel.text = "화"
                    cell.dateLabel.textColor = .black
                case 3:
                    cell.dateLabel.text = "수"
                    cell.dateLabel.textColor = .black
                case 4:
                    cell.dateLabel.text = "목"
                    cell.dateLabel.textColor = .black
                case 5:
                    cell.dateLabel.text = "금"
                    cell.dateLabel.textColor = .black
                case 6:
                    cell.dateLabel.text = "토"
                    cell.dateLabel.textColor = .black
                default:
                    cell.dateLabel.text = "\(indexPath.row)"
                    cell.dateLabel.textColor = .black
                }
            cell.dateLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
            cell.dateLabel.layer.opacity = 0.8
        }
        else{
            firstDay = self.getDayOfWeek("\(self.currentYear)-\(self.currentMonth)-01")!
            if((indexPath.row-6) >= firstDay && (indexPath.row-6) <= self.numOfDaysInMonth[self.currentMonth-1]+firstDay-1){
                switch(indexPath.row % 7){
                case 0:
                    cell.dateLabel.text = "\(indexPath.row-5-firstDay)"
                    cell.dateLabel.textColor = .red
                case 6:
                    cell.dateLabel.text = "\(indexPath.row-5-firstDay)"
                    cell.dateLabel.textColor = .blue
                default:
                    cell.dateLabel.text = "\(indexPath.row-5-firstDay)"
                    cell.dateLabel.textColor = .black
                }
                cell.dateLabel.font = UIFont.boldSystemFont(ofSize: 10.0)
                cell.dateLabel.layer.opacity = 0.8
            }
            else if(indexPath.row-6 < firstDay){ //전달
                var previousYear = -1
                var previousMonth = -1
                if(self.currentMonth == 1){
                    previousYear = self.currentYear-1
                    previousMonth = 12
                }
                else{
                    previousYear = self.currentYear
                    previousMonth = self.currentMonth-1
                }
                if(previousYear % 4 == 0){
                    numOfDaysInMonth[1] = 29
                }
                else{
                    numOfDaysInMonth[1] = 28
                }
                switch(indexPath.row % 7){
                case 0:
                    cell.dateLabel.text = "\(numOfDaysInMonth[previousMonth-1]-firstDay+indexPath.row-5)"
                    cell.dateLabel.textColor = .red
                case 6:
                    cell.dateLabel.text = "\(numOfDaysInMonth[previousMonth-1]-firstDay+indexPath.row-5)"
                    cell.dateLabel.textColor = .blue
                default:
                    cell.dateLabel.text = "\(numOfDaysInMonth[previousMonth-1]-firstDay+indexPath.row-5)"
                    cell.dateLabel.textColor = .black
                }
                cell.dateLabel.font = UIFont.boldSystemFont(ofSize: 10.0)
                cell.dateLabel.layer.opacity = 0.3
            }
            else{
                switch(indexPath.row % 7){ //다음달
                case 0:
                    cell.dateLabel.text = "\(indexPath.row-5-firstDay-numOfDaysInMonth[self.currentMonth-1])"
                    cell.dateLabel.textColor = .red
                case 6:
                    cell.dateLabel.text = "\(indexPath.row-5-firstDay-numOfDaysInMonth[self.currentMonth-1])"
                    cell.dateLabel.textColor = .blue
                default:
                    cell.dateLabel.text = "\(indexPath.row-5-firstDay-numOfDaysInMonth[self.currentMonth-1])"
                    cell.dateLabel.textColor = .black
                }
                cell.dateLabel.font = UIFont.boldSystemFont(ofSize: 10.0)
                cell.dateLabel.layer.opacity = 0.3
            }
            self.dateAtIndex[indexPath.row-7] = cell.dateLabel.text!
        }
        cell.dateLabel.textAlignment = .center
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthPerItem : CGFloat
        let heightPerItem : CGFloat
        if(indexPath.row < 7){
            //월,화 ... 일
            let availableWidth = CalendarCollectionView.frame.width
            widthPerItem = availableWidth / 7 - 2
            heightPerItem = widthPerItem / 2
        }
        else{
            //날짜
            let availableWidth = CalendarCollectionView.frame.width
            widthPerItem = availableWidth / 7 - 2
            heightPerItem = CalendarCollectionView.frame.height / 7
        }
        
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    
    //위아래 라인 간격

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 1
    }
    //옆 라인 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 1
    }
    
    @objc func slideRight(){
        if(self.currentMonth == 12){
            self.currentMonth = 1
            self.currentYear += 1
        }
        else{
            self.currentMonth += 1
        }
        if(self.currentYear % 4 == 0){
            self.numOfDaysInMonth[1] = 29
        }
        else{
            self.numOfDaysInMonth[1] = 28
        }
        self.yearLabel.text = "\(self.currentYear)"
        self.monthLabel.text = "\(self.currentMonth)월"
        self.CalendarCollectionView.reloadData()
    }
    
    @objc func slideLeft(){
        if(self.currentMonth == 1){
            self.currentMonth = 12
            self.currentYear -= 1
        }
        else{
            self.currentMonth -= 1
        }
        if(self.currentYear % 4 == 0){
            self.numOfDaysInMonth[1] = 29
        }
        else{
            self.numOfDaysInMonth[1] = 28
        }
        self.yearLabel.text = "\(self.currentYear)"
        self.monthLabel.text = "\(self.currentMonth)월"
        self.CalendarCollectionView.reloadData()
    }
    
    func deleteAll(){
        for i in (0..<49){
            let cell = CalendarCollectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: IndexPath.init(row: i, section: 0)) as! CalendarCell
            cell.dateLabel.text = ""
            cell.dateLabel.layer.opacity = 1
        }
    }
    
    @IBAction func slideRightBtn(_ sender: Any) {
//        deleteAll()
        slideRight()
    }
    @IBAction func slideLeftBtn(_ sender: Any) {
//        deleteAll()
        slideLeft()
    }
}
