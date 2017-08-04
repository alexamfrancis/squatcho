//
//  Event.swift
//  Squatcho
//
//  Created by Alexandra Francis on 7/20/17.
//  Copyright © 2017 Marlexa. All rights reserved.
//

import UIKit
import CoreLocation

class Event {
    var boundaryMap: [CLLocationCoordinate2D]
    var city: String
    var riddles: [Riddle]
    var treasureCode: String
    var eventDateTime: Date
    var teams = [Team]()
    var winner: Team?
    var submittedPhotos = [UIImage]() // maybe not?
    var dateCreated: Date
    var prizes = [Prize]()
    var description: String
    var rules = [Rule]()
    
    init(boundary:[CLLocationCoordinate2D], city:String, clues:[Riddle], code:String, eventDate:Date, prizes:[Prize], des:String, rules:[Rule]) {
        boundaryMap = boundary
        self.city = city
        riddles = clues
        treasureCode = code
        eventDateTime = eventDate
        dateCreated = Date()
        self.prizes = prizes
        description = des
        self.rules = rules
    }
}

struct Prize {
    var title: String
    var dollarValue: Int
    var description: String
    init(type:String, value:Int, des:String) {
        title = type
        dollarValue = value
        description = des
    }
}

struct Rule {
    var title: String
    var text: String
}

extension CLLocationCoordinate2D {
    func contained(by vertices: [CLLocationCoordinate2D]) -> Bool {
        let path = CGMutablePath()
        
        for vertex in vertices {
            if path.isEmpty {
                path.move(to: CGPoint(x: vertex.longitude, y: vertex.latitude))
            } else {
                path.addLine(to: CGPoint(x: vertex.longitude, y: vertex.latitude))
            }
        }
        
        let point = CGPoint(x: self.longitude, y: self.latitude)
        return path.contains(point)
    }
}
