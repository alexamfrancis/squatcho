//
//  AppState.swift
//  Squatcho
//
//  Created by Alexandra Francis on 8/3/17.
//  Copyright © 2017 Marlexa. All rights reserved.
//

import Foundation

class AppState {
    var loggedIn: Bool
    var user: User?
    let defaults = UserDefaults.standard

    init() {
        if defaults.object(forKey: Constants.savedStateLoggedIn) != nil {
            loggedIn = defaults.bool(forKey: Constants.savedStateLoggedIn)
        } else {
            loggedIn = false
        }
        if defaults.object(forKey: Constants.savedStateUser) != nil {
            user = defaults.object(forKey: Constants.savedStateUser) as! User
        } else {
            user = nil
        }
    }
}
