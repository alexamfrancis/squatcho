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
    var startedLoggedin: Bool = false

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
                    self.storeTokens(accessToken)//, refreshToken: refreshToken)
                    self.retrieveProfile(callback)
                case .failure(let error):
                    callback(error)
                    self.logout()
                }
        }
    }
    
    func getMetadata(idToken: String, profile: UserInfo) {
        Auth0
            .users(token: idToken)
            .get(profile.sub, fields: ["user_id", "email"], include: true)
            .start { result in
                switch result {
                case .success(let user):
                    guard let uid = user["user_id"] as? String else { return }
                    guard let email = user["email"] as? String else {
                        print("Missing Email Address")
                        return
                    }
                    PymongoService.shared.getUser(uid: uid, email: email) { user in
                        
                    }
                    
                case .failure( _): break
                    // Deal with failure
                }
        }
    }
    
    func logout() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(false, forKey: Constants.savedStateLoggedIn)
        userDefaults.removeObject(forKey: Constants.savedStateUser)
        userDefaults.synchronize()
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
