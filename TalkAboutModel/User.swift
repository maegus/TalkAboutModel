//
//  User.swift
//  TalkAboutModel
//
//  Created by draveness on 12/03/2017.
//  Copyright © 2017 draveness. All rights reserved.
//

import Foundation
import Alamofire

struct User {
    enum Gender: String {
        case male = "male"
        case female = "female"
        
        init?(rawInt: Int) {
            if rawInt == 0 {
                self.init(rawValue: "male")
            } else {
                self.init(rawValue: "female")
            }
        }
    }
    let id: Int
    let name: String
    let email: String
    let age: Int
    let gender: Gender
}


extension User: RESTful {
    static var url: String {
        return "http://localhost:3000/users"
    }

    init?(json: [String: Any]) {
        guard let id = json["id"] as? Int,
            let name = json["name"] as? String,
            let email = json["email"] as? String,
            let age = json["age"] as? Int,
            let genderValue = json["gender"] as? Int,
            let gender = Gender(rawInt: genderValue) else {
                return nil
        }
        self.init(id: id, name: name, email: email, age: age, gender: gender)
    }
}

protocol RESTful {
    init?(json: [String: Any])
    static var url: String { get }
}

extension RESTful {
    static func index(completion: @escaping ([Self]) -> ()) {
        Alamofire.request(url).responseJSON { response in
            if let jsons = response.result.value as? [[String: Any]] {
                let models = jsons.flatMap(self.init)
                completion(models)
            }
        }
    }
    
    static func show(id: Int, completion: @escaping (Self?) -> ()) {
        Alamofire.request("\(url)/\(id)").responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                completion(self.init(json: json))
            }
        }
    }
    
    static func create(params: [String: Any], completion: @escaping (Self?) -> ()) {
        Alamofire.request(url, method: .post, parameters: ["user": params]).responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                completion(self.init(json: json))
            }
        }
    }
    
    static func update(id: Int, params: [String: Any], completion: @escaping (Self?) -> ()) {
        Alamofire.request("\(url)/\(id)", method: .put, parameters: ["user": params]).responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                completion(self.init(json: json))
            }
        }
    }
    
    static func delete(id: Int, completion: @escaping () -> ()) {
        Alamofire.request("\(url)/\(id)", method: .delete).responseJSON { response in
            completion()
        }
    }
}
