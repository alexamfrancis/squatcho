
//
//  Team.swift
//  Squatcho
//
//  Created by Alexandra Francis on 7/20/17.
//  Copyright © 2017 Marlexa. All rights reserved.
//

import UIKit

class Team {
    var uniqueTeamName: String
    var teamLeader: User
    var teamMembers = [User]()
    var currentRiddle: Riddle?
    var currentRiddleStartTime: Date?
    var completedRiddles = [CompletedRiddle]()
 
    init(name:String, leader:User) {
        uniqueTeamName = name
        teamLeader = leader
    }
    
    func addTeamMember(user:User) -> [User] {
        user.changeStatus(to: Constants.kMember)
        teamMembers.append(user)
        return teamMembers
    }
    
    func removeTeamMember(user:User) {
        let updatedTeam = teamMembers.filter{$0 !== user}
        teamMembers = updatedTeam
    }
    
    // used for the first riddle
    func newRiddle(riddle: Riddle) {
        currentRiddle = riddle
        currentRiddleStartTime = Date()
        // wait 2 hours (7200 seconds) before giving a hint
        delay(7200) {
            // check to see if we've moved on yet
            if riddle === self.currentRiddle! {
                self.showHint()
            }
        }
    }
    
    func showHint() {
        // DO SOMETHING HERE!
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    // used to complete a riddle and update with a new riddles
    func nextRiddle(newRiddle:Riddle, photo:UIImage) {
        // if this isnt the first riddle add it to completed riddles and update items
        if let last = currentRiddle, let startTime = currentRiddleStartTime {
            let duration = getDurationSeconds(start: startTime)
            last.updateAvgDuration(duration: duration)
            let completed = CompletedRiddle(riddle:last, dur: duration, pic:photo)
            completedRiddles.append(completed)
        }
        self.newRiddle(riddle: newRiddle)
    }
    
    func getDurationSeconds(start:Date) -> Double {
        return DateInterval(start: start, end: Date()).duration
    }
}

struct CompletedRiddle {
    var riddle: Riddle
    var durationSeconds: Double
    var photo: UIImage
    
    init(riddle:Riddle, dur:Double, pic:UIImage) {
        self.riddle = riddle
        durationSeconds = dur
        photo = pic
    }
}
