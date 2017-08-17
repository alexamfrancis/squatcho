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

    func getUser(uid: String, email: String, respond: @escaping (_: User) -> Void) {
        print(uid + email)
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
                    if let team = value["teamName"] as? String {
                        let user = User(email: email, id: uid, status: userStatus, team: team)
                        SessionManager.shared.user = user
                        respond(user)
                    } else {
                        let user = User(email: email, id: uid, status: userStatus)
                        SessionManager.shared.user = user
                        respond(user)
                    }
                }
            }
        }
    }
    
    /// Called ONLY when user is leader status and has a team name // response contains updated team
    func inviteMembers(memberId: String) {
        if SessionManager.shared.user?.userStatus == UserStatus.leader, let team = SessionManager.shared.user?.teamName {
            let params:Parameters = ["userId":memberId, "teamName": team]
            Alamofire.request(Constants.inviteURL, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in print(response.result.value ?? "ERROR: NO RETURN VALUE") }
        }
    }
    
    /// Called ONLY when user is leader status and team members // response contains updated team
    func removeMember(memberId: String) {
        if SessionManager.shared.user?.userStatus == UserStatus.leader, let team = SessionManager.shared.user?.teamName {
            let params:Parameters = ["userId": memberId, "teamName": team]
            Alamofire.request(Constants.inviteURL, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in print(response.result.value ?? "ERROR: NO RETURN VALUE") }
        }
    }

    /// Called ONLY when the user has a pending invitation // response contains updated user
    func acceptInvitation() {
        if SessionManager.shared.user?.userStatus == UserStatus.pending, let team = SessionManager.shared.user?.teamName {
            let params:Parameters = ["userId":SessionManager.shared.user!.id, "teamName": team]
            Alamofire.request(Constants.acceptURL, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in print(response.result.value ?? "ERROR: NO RETURN VALUE") }
        }
    }
    
    /// Called ONLY when user is leader status // response contains the team that has invited them
    func checkPending() {
        if SessionManager.shared.user?.userStatus == UserStatus.pending {
            let params:Parameters = ["userId":SessionManager.shared.user!.id]
            Alamofire.request(Constants.acceptURL, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in print(response.result.value ?? "ERROR: NO RETURN VALUE") }
        }
    }
}
