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
    @IBOutlet weak var loginOrSignUpButton: UIButton!
    @IBAction func showLoginController(_ sender: UIButton) {
        self.showLogin()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loginOrSignUpButton.layer.cornerRadius = 10
        loginOrSignUpButton.clipsToBounds = true
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
        Auth0.webAuth().scope("openid profile offline_access").audience("https://" + clientInfo.domain + "/userinfo").start {
                switch $0 {
                case .failure(let error):
                    // Handle the error
                    print("Error: \(error)")
                case .success(let credentials):
                    guard let accessToken = credentials.accessToken, let refreshToken = credentials.refreshToken else { return }
                    SessionManager.shared.storeTokens(accessToken, refreshToken: refreshToken)
                    SessionManager.shared.retrieveProfile { error in
                        DispatchQueue.main.async {
                            guard let id = credentials.idToken else {
                                print("ERROR ON ID TOKEN")
                                return
                            }
                            guard let profile = SessionManager.shared.profile else {
                                print("ERROR ON PROFILE")
                                return
                            }
                            SessionManager.shared.getMetadata(idToken: id , profile: profile)
                            UserDefaults.standard.set(true, forKey: Constants.savedStateLoggedIn)
                            UserDefaults.standard.synchronize()
                            self.dismiss(animated: true, completion: nil)
                            self.performSegue(withIdentifier: Constants.homeSegueIdentifier, sender: nil)
                        }
                    }
                }
        }
    }

    fileprivate func checkToken() {
        let loadingAlert = UIAlertController.loadingAlert()
        loadingAlert.presentInViewController(self)
        SessionManager.shared.retrieveProfile { error in
            DispatchQueue.main.async {
                loadingAlert.dismiss(animated: true) {
                    guard error == nil else {
                        return self.showLogin()
                    }
                    UserDefaults.standard.set(true, forKey: Constants.savedStateLoggedIn)
                    self.dismiss(animated: true, completion: nil)
                    //self.openRevealVC()
                    self.performSegue(withIdentifier: Constants.homeSegueIdentifier, sender: nil)
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIAlertController {

    static func loadingAlert() -> UIAlertController {
        return UIAlertController(title: "Loading", message: "Please, wait...", preferredStyle: .alert)
    }

    func presentInViewController(_ viewController: UIViewController) {
        viewController.present(self, animated: true, completion: nil)
    }

}

