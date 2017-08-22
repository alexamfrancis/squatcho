//
//  AccountViewController.swift
//  Squatcho
//
//  Created by Alexandra Francis on 7/19/17.
//  Copyright © 2017 Marlexa. All rights reserved.
//

import UIKit
import SimpleKeychain

class AccountViewController: UIViewController {
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    @IBAction func tappedLogOut() {
        let alertController = UIAlertController(title: "Log Out", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Nope", style: .cancel) { action in
            // ...
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Yep", style: .default) { action in
            SessionManager.shared.logout()
            self.presentingViewController?.dismiss(animated: true, completion: nil)
            if SessionManager.shared.startedLoggedin {
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let homeVC: HomeViewController = storyboard.instantiateViewController(withIdentifier: Constants.homeViewControllerIdentifier) as! HomeViewController
                self.navigationController?.pushViewController(homeVC, animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.selectHomeMenuItem), object: nil)

                let loginVC:LoginViewController = storyboard.instantiateViewController(withIdentifier: Constants.loginVCIdentifier) as! LoginViewController
                self.navigationController?.showDetailViewController(loginVC, sender: nil)
            } else {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true) {
            // ...
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
