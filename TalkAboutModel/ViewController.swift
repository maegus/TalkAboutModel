//
//  ViewController.swift
//  TalkAboutModel
//
//  Created by draveness on 12/03/2017.
//  Copyright © 2017 draveness. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let nameLabel = UILabel()
    let emailLabel = UILabel()
    let ageLabel = UILabel()
    let genderLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        User.index { (users) in
            print(users)
        }
        
        User.create(params: ["name": "Stark", "email": "example@email.com", "gender": 0, "age": 100]) { (user) in
            print(user!)
        }
    }
}

