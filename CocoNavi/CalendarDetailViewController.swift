//
//  CalendarDetailViewController.swift
//  CocoNavi
//
//  Created by 우원진 on 2020/07/23.
//  Copyright © 2020 WooWonJin. All rights reserved.
//

import UIKit
import FirebaseAuth
import Alamofire

class CalendarDetailViewCell: UITableViewCell{
    @IBOutlet weak var eventLabel: UILabel!
}

class CalendarDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    

    @IBOutlet weak var eventTable: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    var year : String = ""
    var month : String = ""
    var date : String = ""
    var pets : Array<Pet> = []
    let URL = "http://127.0.0.1:8000/"
    
    var events : Array<Event> = []
    
    
    func getEvents(){
        let headers : HTTPHeaders = [ "Accept":"application/json" ,  "Content-Type": "application/json", "X-CSRFToken": "", "charset":"utf-8"]
        let params = ["uid": Auth.auth().currentUser?.uid,
                      "date": "\(self.year)-\(self.month)-\(self.date)"
                      ]
        let url = self.URL+"events/get-events-date/"
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch(response.result){
            case .success(let value):
                let responseList = value as! Array<AnyObject>
                self.events.removeAll()
                print("list : " ,responseList)
                for (index, _) in responseList.enumerated(){
                    let title = responseList[index]["title"] as! String
                    let pet = responseList[index]["pet_name"] as! String
                    let text = responseList[index]["text"] as! String
                    let date = responseList[index]["date"] as! String
                    let pk = responseList[index]["pk"] as! String
                    self.events.insert(Event(pk: pk, title: title, date: date, text: text, pet: pet), at: index)
                }
                self.eventTable.reloadData()
            case .failure(let error):
                print("Error : Something Wrong")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getEvents()
        self.eventTable.delegate = self
        self.eventTable.dataSource = self
        self.dateLabel.text = "\(self.month)월 \(self.date)일"
        let bounds = UIScreen.main.bounds
        let deviceWidth = bounds.width
        let deviceHeight = bounds.height
        let tabHeight = self.tabBarController?.tabBar.frame.size.height
        let addBtn = UIButton()
        addBtn.setTitle("+", for: .normal)
//        addBtn.titleLabel?.font = UIFont(name: "System", size: 30) font 고치기 !!
        addBtn.backgroundColor = .orange
        addBtn.frame = CGRect(x: deviceWidth-90, y: deviceHeight-tabHeight!-90, width: 70, height: 70)
        addBtn.layer.cornerRadius = addBtn.layer.frame.width/2
        addBtn.addTarget(self, action: #selector(addBtnClicked), for: .touchUpInside)
        self.view.addSubview(addBtn)
        var leftSwipe : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(slideLeft))
        leftSwipe.direction = .right
        self.view.addGestureRecognizer(leftSwipe)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getEvents()
    }
    
    @objc func addBtnClicked(){
        let addView = self.storyboard?.instantiateViewController(identifier: "EventAddView") as! EventAddViewController
        addView.year = self.year
        addView.month = self.month
        addView.day = self.date
        addView.pets = self.pets
        self.navigationController?.pushViewController(addView, animated: true)
    }

    @objc func slideLeft(){
        self.navigationController?.popViewController(animated: true)
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.eventTable.dequeueReusableCell(withIdentifier: "CalendarDetailViewCell", for: indexPath) as! CalendarDetailViewCell
        cell.selectionStyle = .none
        cell.eventLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.eventLabel.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 20).isActive = true
        cell.eventLabel.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
        cell.eventLabel.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        cell.eventLabel.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
        cell.eventLabel.heightAnchor.constraint(equalTo: cell.heightAnchor).isActive = true
        cell.eventLabel.widthAnchor.constraint(equalTo: cell.widthAnchor).isActive = true
        cell.eventLabel.text = "\(self.events[indexPath.row].title) (\(self.events[indexPath.row].pet))"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addView = self.storyboard?.instantiateViewController(identifier: "EventAddView") as! EventAddViewController
        let event = self.events[indexPath.row]
        addView.year = self.year
        addView.month = self.month
        addView.day = self.date
        addView.pets = self.pets
        addView.pet = event.pet
        addView.firstEventTitle = event.title
        addView.firstText = event.text
        addView.pk = event.pk
        self.navigationController?.pushViewController(addView, animated: true)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
