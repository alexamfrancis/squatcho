//
//  Riddle.swift
//  Squatcho
//
//  Created by Alexandra Francis on 7/20/17.
//  Copyright © 2017 Marlexa. All rights reserved.
//

import UIKit
import CoreLocation

enum Difficulty: Int {
    case veryEasy
    case easy
    case easyMedium
    case medium
    case mediumHard
    case hard
    case veryHard
    case bonus
}

class Riddle {
    var riddleQuestion: String
    var hint: String
    var difficulty: Difficulty
    var destinationIdentifier: String // name of riddle destination
    var destinationCoordinate: CLLocationCoordinate2D // lat, long
    var bufferRadius: CLLocationDistance // in meters
    var dateCreated: Date
    var averageSolveTimeSeconds: Double // in seconds
    var numTimesSolved: Int
    
    init(question:String, hint:String, dif:Difficulty, identifier:String, coord:CLLocationCoordinate2D, buffer:CLLocationDistance) {
        riddleQuestion = question
        self.hint = hint
        difficulty = dif
        destinationIdentifier = identifier
        destinationCoordinate = coord
        bufferRadius = buffer
        dateCreated = Date()
        numTimesSolved = 0
        averageSolveTimeSeconds = 0.0
    }
    
    func updateAvgDuration(duration:Double) {
        if numTimesSolved == 0 {
            averageSolveTimeSeconds = duration
        } else {
            averageSolveTimeSeconds = (averageSolveTimeSeconds + duration) / 2
        }
        numTimesSolved += 1
    }
    
    func getAvgSolveMinutes() -> Double {
        return averageSolveTimeSeconds * 60
    }
}

/*
 let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
 let radius: CLLocationDistance = 60350.4    // meters for 37.5 miles
 let regionIdentifier = "CircularRegion"     // any desired String
 
 let circularRegion = CLCircularRegion(center: center, radius: radius, identifier: regionIdentifier)
*/
