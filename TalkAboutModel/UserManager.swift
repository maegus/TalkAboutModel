//
//  UserManager.swift
//  TalkAboutModel
//
//  Created by draveness on 14/03/2017.
//  Copyright © 2017 draveness. All rights reserved.
//

import Foundation
import Alamofire

final class UserManager {
    static let baseURL = "http://localhost:3000"
    static let usersBaseURL = "\(baseURL)/users"

    static func allUsers(completion: @escaping ([User]) -> ()) {
        let url = "\(usersBaseURL)"
        Alamofire.request(url).responseJSON { response in
            if let jsons = response.result.value as? [[String: Any]] {
                let users = jsons.flatMap(User.init)
                completion(users)
            }
        }
    }
    
    static func user(id: Int, completion: @escaping (User) -> ()) {
        let url = "\(usersBaseURL)/\(id)"
        Alamofire.request(url).responseJSON { response in
            if let json = response.result.value as? [String: Any],
                let user = User(json: json) {
                completion(user)
            }
        }
    }
}

protocol Declarative {
    var requestURL: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
}

extension Declarative {
    func start(completion: @escaping (Any) -> Void) {
        Alamofire.request(requestURL, method: self.method).responseJSON { response in
            if let json = response.result.value {
                completion(json)
            }
        }
    }
}

final class AllUsersManager: Declarative {
    let requestURL = "http://localhost:3000/users"
    let method = HTTPMethod.get
    let parameters: Parameters? = nil
}

final class FindUserManager: Declarative {
    let requestURL: String
    let method = HTTPMethod.get
    let parameters: Parameters? = nil
    
    init(id: Int) {
        self.requestURL = "http://localhost:3000/users/\(id)"
    }
}
















