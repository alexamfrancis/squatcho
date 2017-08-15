//
//  Constants.swift
//  Squatcho
//
//  Created by Alexandra Francis on 7/24/17.
//  Copyright © 2017 Marlexa. All rights reserved.
//

import Foundation

public struct Constants {
    static let homeNullViewIdentifier = "HomeStatusViewController"
    static let detailCellId = "DetailsTableViewCell"
    static let detailsViewControllerIdentifier = "DetailVC"
    static let selectDetailsMenuItem = "selectDetailsMenuItem"
    static let savedStateLoggedIn = "savedStateLogin"
    static let savedStateUser = "savedStateUser"
    static let homeSegueIdentifier = "ShowHomeNonAnimated"
    
    
    static let rule1 = Rule(title: "The Hunt", text: "When the hunt starts, your first riddle is revealed. Solve the riddle to find out where to go next. When you make it to the correct location, you will be prompted to take a team picture to unlock the next riddle. Once you solve all of the riddles, adventuring around SLO, the final riddle will give you the code to the treasure chest with $10,000. If you get there with the code first, it’s yours.")
    static let rule2 = Rule(title: "The Team", text: "There's a $20 flat fee for a team of up to 4 teammates. Fewer teammates means your portion is bigger, but less brain power for solving riddles. Once you've registered a team, you are in charge of inviting the smartest, quickest, and most fun of your friends to join your team. Or, join a friends team and help them towards victory.")
    static let rule4 = Rule(title: "The Map", text: "The riddles may require a drive, hike, or another mode of transportation. None of the riddles will take you out of the bounds of the map, so if you see your little blue dot outside of the red boundary, you've gone astray. None of the riddles require paying more money (except maybe gas), so don't go paying people to get ahead. If you haven’t solved a riddle after 2 hours, we will give you a hint to help you out.")
    static let rule3 = Rule(title: "The Picture", text: "Once the event starts, teams are locked. All team members must be in every team picture. If a teammate has to leave in the middle and misses a picture, that clue hasn’t been solved. Make sure all teammates are committed to be there that day, if you want to be eligible to win.")
    static let rule5 = Rule(title: "The Winner", text: "We will divide the $10,000 equally between the teammates, whether there is 1, 2, 3, or 4 people on your team. People that aren’t listed under My Team will not get any money. If someone under My Team didn’t end up participating, they will still get their portion of the winnings.")
    static let rule6 = Rule(title: "The Rules", text: "Every team member must be at each riddle location and in the picture (take a selfie if there’s nobody around). Teams are limited to 4 members. Obey all laws on and off the road during this race. Breach of rules can result in immediate disqualification.")
    static let rules = [rule1, rule2, rule3, rule4, rule5, rule6]
}
