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
            print(response)
            if let value = response.result.value {
                if let val = value as? [String:Any], let status = val["status"] as? String {
                    var user: User
                    if let val = value as? [String:Any], let team = val["teamName"] as? String {
                        user = User(email: email, id: uid, status: status, team: team)
                    } else {
                        user = User(email: email, id: uid, status: status)
                    }
                    let userDefaults = UserDefaults.standard
                    let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: user)
                    userDefaults.set(encodedData, forKey: Constants.savedStateUser)
                    userDefaults.synchronize()
                    SessionManager.shared.user = user
                    respond(user)
                }
            }
        }
    }
    
    /// Called ONLY when user is leader status and has a team name // response contains updated team
    func inviteMembers(memberId: String) {
        if SessionManager.shared.user?.userStatus == Constants.kLeader, let team = SessionManager.shared.user?.teamName {
            let params:Parameters = ["userId":memberId, "teamName": team]
            Alamofire.request(Constants.inviteURL, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in print(response.result.value ?? "ERROR: NO RETURN VALUE") }
        }
    }
    
    /// Called ONLY when user is leader status and team members // response contains updated team
    func removeMember(memberId: String) {
        if SessionManager.shared.user?.userStatus == Constants.kLeader, let team = SessionManager.shared.user?.teamName {
            let params:Parameters = ["userId": memberId, "teamName": team]
            Alamofire.request(Constants.inviteURL, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in print(response.result.value ?? "ERROR: NO RETURN VALUE") }
        }
    }

    /// Called ONLY when the user has a pending invitation // response contains updated user
    func acceptInvitation() {
        if SessionManager.shared.user?.userStatus == Constants.kPending, let team = SessionManager.shared.user?.teamName {
            let params:Parameters = ["userId":SessionManager.shared.user!.id, "teamName": team]
            Alamofire.request(Constants.acceptURL, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
                SessionManager.shared.user?.userStatus = Constants.kMember
                print(response.result.value ?? "ERROR: NO RETURN VALUE")
            }
        }
    }
    
    /// Called ONLY when user is leader or member status // response contains the team with the leader first
    func getMyTeam(respond: @escaping (_: [String]) -> Void) {
        if let team = SessionManager.shared.user?.teamName {
            let params:Parameters = ["teamName": team]
            Alamofire.request(Constants.myTeamURL, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
                if let team = response.result.value as? [String:Any] {
                    if let leader = team["leaderId"] as? String, let members = team["memberIds"] as? [String] {
                        var wholeTeam: [String] = members
                        wholeTeam.insert(leader, at: 0)
                        respond(wholeTeam)
                    }
                }
            }
        }
    }
    /// Called ONLY when user is leader status // response contains the team that has invited them
    func getAllAvailableUsers (respond: @escaping (_: [String]) -> Void) {
        if SessionManager.shared.user?.userStatus == Constants.kLeader {
            Alamofire.request(Constants.availableUsersURL, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
                var emailList = [String]()
                if let users = response.result.value as? [[String:Any]] {
                    for user in users {
                        if let email = user["email"] as? String {
                            emailList.append(email)
                        }
                    }
                }
                respond(emailList)
            }
        }
    }
    
    /// Called for null local status // response contains the team that has invited them
    func checkPending(respond: @escaping (_: Bool) -> Void) {
        if SessionManager.shared.user?.userStatus == Constants.kPending {
            let params:Parameters = ["userId":SessionManager.shared.user!.id]
            Alamofire.request(Constants.checkPendingURL, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
                if let value = response.result.value as? [String:Any], let team = value["teamName"] as? String {
                    print(team)
                    SessionManager.shared.user?.changeStatus(to: Constants.kPending)
                    SessionManager.shared.user?.teamName = team
                    respond(true)
                }
                respond(false)
            }
        }
    }
}
