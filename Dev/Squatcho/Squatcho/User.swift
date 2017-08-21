//
//  User.swift
//  Squatcho
//
//  Created by Alexandra Francis on 7/20/17.
//  Copyright © 2017 Marlexa. All rights reserved.
//

import UIKit
import CoreLocation

class User: NSObject, NSCoding {
    var id: String
    var emailAddress: String
    var teamName: String
    var userStatus: String

    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as! String
        let email = aDecoder.decodeObject(forKey: "email") as! String
        let team = aDecoder.decodeObject(forKey: "team") as! String
        let status = aDecoder.decodeObject(forKey: "status") as! String
        self.init(email: email, id: id, status: status, team: team)

    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(emailAddress, forKey: "email")
        aCoder.encode(teamName, forKey: "team")
        aCoder.encode(userStatus, forKey: "status")
    }

    override init() {
        id = ""
        emailAddress = ""
        teamName = ""
        userStatus = Constants.kNull
    }
    
    init(email:String, id: String, status: String) {
        self.id = id
        emailAddress = email
        teamName = ""
        userStatus = status
    }
    
    init(email:String, id: String, status: String, team: String) {
        self.id = id
        emailAddress = email
        teamName = team
        userStatus = status
    }
    
    func changeStatus(to new:String) {
        userStatus = new
    }
}
