//
//  PymongoService.swift
//  Squatcho
//
//  Created by Alexandra Francis on 8/15/17.
//  Copyright © 2017 Marlexa. All rights reserved.
//

import Foundation
import Alamofire

class PymongoService {
    static let shared = PymongoService()
    private init () { }

    func getUser(uid: String, email: String, respond: (_: User) -> Void) {
        let params:Parameters = ["userId":uid, "email":email]
        
        Alamofire.request(Constants.getUserURL, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            if let value = response.result.value as? [String:Any] {
                if let status = value["status"] as? String {
                    var userStatus: UserStatus
                    switch status {
                    case "null":
                        userStatus = UserStatus.null
                    case "pending":
                        userStatus = UserStatus.pending
                    case "leader":
                        userStatus = UserStatus.leader
                    case "member":
                        userStatus = UserStatus.member
                    default:
                        userStatus = UserStatus.null
                    }
                    respond(User(email: email, id: uid, status: userStatus))
                }
            }
        }
    }
    
    func updateUserStatus(uid: String, status: UserStatus) {
        SessionManager.shared.user?.changeStatus(to: status)
        var userStatus: String
        switch status {
        case UserStatus.null:
            userStatus = "null"
        case UserStatus.pending:
            userStatus = "pending"
        case UserStatus.leader:
            userStatus = "leader"
        case UserStatus.member:
            userStatus = "member"
        default:
            userStatus = "null"
        }
        let params:Parameters = ["userId":uid, "status":userStatus]
        Alamofire.request(Constants.updateUserURL, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in print(response.result.value ?? "ERROR: NO RETURN VALUE") }
    }
}
