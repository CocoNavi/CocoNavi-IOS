//
//  EventAddViewController.swift
//  CocoNavi
//
//  Created by 우원진 on 2020/07/23.
//  Copyright © 2020 WooWonJin. All rights reserved.
//

import UIKit

class EventAddViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var leftSwipe : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(slideLeft))
        leftSwipe.direction = .right
        self.view.addGestureRecognizer(leftSwipe)
    }
    
    @objc func slideLeft(){
        self.navigationController?.popViewController(animated: true)
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
