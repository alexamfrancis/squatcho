//
//  LoginViewController.swift
//  Squatcho
//
//  Created by Alexandra Francis on 8/10/17.
//  Copyright © 2017 Marlexa. All rights reserved.
//

import UIKit
import Auth0
import SimpleKeychain

class LoginViewController: UIViewController {
    @IBAction func showLoginController(_ sender: UIButton) {
        self.showLogin()
//        guard let clientInfo = plistValues(bundle: Bundle.main) else { return }
//        Auth0
//            .webAuth()
//            .audience("https://" + clientInfo.domain + "/userinfo")
//            .start {
//                switch $0 {
//                case .failure(let error):
//                    print("Error: \(error)")
//                case .success(let credentials):
//                    guard let accessToken = credentials.accessToken else { return }
//                    let keychain = A0SimpleKeychain(service: "Auth0")
//                    keychain.setString(accessToken, forKey: "access_token")
//
//                    self.openRevealVC(accessToken)
//
//                }
//        }
//
//        Auth0
//            .webAuth()
//            .scope("openid profile offline_access")
//            .start {
//                switch $0 {
//                case .failure(let error):
//                    // Handle the error
//                    print("Error: \(error)")
//                case .success(let credentials):
//                    guard let accessToken = credentials.accessToken, let refreshToken = credentials.refreshToken else { return }
//                    let keychain = A0SimpleKeychain(service: "Auth0")
//                    keychain.setString(accessToken, forKey: "access_token")
//                    keychain.setString(refreshToken, forKey: "refresh_token")
//                }
//        }
//
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func openRevealVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let revealVC: SWRevealViewController = storyboard.instantiateViewController(withIdentifier: "revealVC") as! SWRevealViewController
        show(revealVC, sender: nil)
    }
    
    // MARK: - Private
    
    fileprivate func showLogin() {
        guard let clientInfo = plistValues(bundle: Bundle.main) else { return }
        Auth0
            .webAuth()
            .scope("openid profile offline_access")
            .audience("https://" + clientInfo.domain + "/userinfo")
            .start {
                switch $0 {
                case .failure(let error):
                    // Handle the error
                    print("Error: \(error)")
                case .success(let credentials):
                    guard let accessToken = credentials.accessToken, let refreshToken = credentials.refreshToken else { return }
                    SessionManager.shared.storeTokens(accessToken, refreshToken: refreshToken)
                    SessionManager.shared.retrieveProfile { error in
                        DispatchQueue.main.async {
                            self.openRevealVC()
                        }
                    }
                }
        }
    }
    
//    fileprivate func checkToken() {
//        let loadingAlert = UIAlertController.loadingAlert()
//        loadingAlert.presentInViewController(self)
//        SessionManager.shared.retrieveProfile { error in
//            DispatchQueue.main.async {
//                loadingAlert.dismiss(animated: true) {
//                    guard error == nil else {
//                        return self.showLogin()
//                    }
//                    self.openRevealVC() // MAYBE CHANGE THIS?!?
//                }
//            }
//        }
//    }
//
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//func plistValues(bundle: Bundle) -> (clientId: String, domain: String)? {
//    guard
//        let path = bundle.path(forResource: "Auth0", ofType: "plist"),
//        let values = NSDictionary(contentsOfFile: path) as? [String: Any]
//        else {
//            print("Missing Auth0.plist file with 'ClientId' and 'Domain' entries in main bundle!")
//            return nil
//    }
//
//    guard
//        let clientId = values["ClientId"] as? String,
//        let domain = values["Domain"] as? String
//        else {
//            print("Auth0.plist file at \(path) is missing 'ClientId' and/or 'Domain' entries!")
//            print("File currently has the following entries: \(values)")
//            return nil
//    }
//    return (clientId: clientId, domain: domain)
//}
//
//
//extension UIAlertController {
//
//    static func loadingAlert() -> UIAlertController {
//        return UIAlertController(title: "Loading", message: "Please, wait...", preferredStyle: .alert)
//    }
//
//    func presentInViewController(_ viewController: UIViewController) {
//        viewController.present(self, animated: true, completion: nil)
//    }
//
//}

