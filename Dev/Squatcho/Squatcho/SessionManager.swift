//
//  SessionManager.swift
//  Squatcho
//
//  Created by Alexandra Francis on 8/3/17.
//  Copyright © 2017 Marlexa. All rights reserved.
//

import Foundation
import SimpleKeychain
import Auth0

enum SessionManagerError: Error {
    case noAccessToken
    case noRefreshToken
}

class SessionManager {
    static let shared = SessionManager()
    let keychain = A0SimpleKeychain(service: "Auth0")
    var profile: UserInfo?
    var user: User?

    private init () { }
    
    func storeTokens(_ accessToken: String, refreshToken: String? = nil) {
        self.keychain.setString(accessToken, forKey: "access_token")
        if let refreshToken = refreshToken {
            self.keychain.setString(refreshToken, forKey: "refresh_token")
        }
    }
    
    func retrieveProfile(_ callback: @escaping (Error?) -> ()) {
        guard let accessToken = self.keychain.string(forKey: "access_token") else {
            return callback(SessionManagerError.noAccessToken)
        }
        Auth0
            .authentication()
            .userInfo(withAccessToken: accessToken)
            .start { result in
                switch(result) {
                case .success(let profile):
                    self.profile = profile
                    self.getUserId(accessToken: accessToken)
                    callback(nil)
                case .failure(_):
                    self.refreshToken(callback)
                }
        }
    }
    
    func refreshToken(_ callback: @escaping (Error?) -> ()) {
        guard let refreshToken = self.keychain.string(forKey: "refresh_token") else {
            return callback(SessionManagerError.noRefreshToken)
        }
        Auth0
            .authentication()
            .renew(withRefreshToken: refreshToken, scope: "openid profile offline_access")
            .start { result in
                switch(result) {
                case .success(let credentials):
                    guard let accessToken = credentials.accessToken else { return }
                    self.storeTokens(accessToken)
                    self.retrieveProfile(callback)
                case .failure(let error):
                    callback(error)
                    self.logout()
                }
        }
    }
    
    func getUserId(accessToken: String) {
        let headers = ["authorization": "Bearer \(accessToken)"]
        let url = URL(fileURLWithPath: "https://squatcho.auth0.com/api/v2/users/USER_ID")
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                let httpResponse = response as? HTTPURLResponse
                guard let user_id = httpResponse?.allHeaderFields["user_id"] as? String else {return}
                guard let email = httpResponse?.allHeaderFields["email"] as? String else {return}
                PymongoService.shared.getUser(uid: user_id, email: email) { newUser in
                    UserDefaults.standard.set(user_id, forKey: Constants.savedStateUser)
                }

                print(httpResponse ?? "ERROR ON RESPONSE FOR USER_ID")
            }
        })
        
        dataTask.resume()
    }
    
    func logout() {
        UserDefaults.standard.set(false, forKey: Constants.savedStateLoggedIn)
        self.keychain.clearAll()
    }
    
}

func plistValues(bundle: Bundle) -> (clientId: String, domain: String)? {
    guard
        let path = bundle.path(forResource: "Auth0", ofType: "plist"),
        let values = NSDictionary(contentsOfFile: path) as? [String: Any]
        else {
            print("Missing Auth0.plist file with 'ClientId' and 'Domain' entries in main bundle!")
            return nil
    }
    
    guard
        let clientId = values["ClientId"] as? String,
        let domain = values["Domain"] as? String
        else {
            print("Auth0.plist file at \(path) is missing 'ClientId' and/or 'Domain' entries!")
            print("File currently has the following entries: \(values)")
            return nil
    }
    return (clientId: clientId, domain: domain)
}
//class AppState {
//    var loggedIn: Bool
//    var user: User?
//    let defaults = UserDefaults.standard
//
//    init() {
//        let keychain = A0SimpleKeychain(service: "Auth0")
//        guard let accessToken = keychain.string(forKey: "access_token") else {
//            // accessToken doesn't exist, user has to enter their credentials to log in
//            // Present the Login
//            loggedIn = false
//            return
//        }
//
//        loggedIn = true
//
//        if defaults.object(forKey: Constants.savedStateUser) != nil {
//            user = defaults.object(forKey: Constants.savedStateUser) as! User
//        } else {
//            user = nil
//        }
//    }
//}

