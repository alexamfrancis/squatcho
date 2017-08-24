//
//  HomeStatusViewController.swift
//  
//
//  Created by Alexandra Francis on 7/24/17.
//
//

import UIKit

class HomeStatusViewController: UIViewController {
    var userStatus: String
    
    @IBOutlet weak var registerButton: UIButton!
    @IBAction func tappedRegisterButton(_ sender: Any) {
        // open hook page controller
        let newViewController = HookPageViewController()
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    init(with status: String) {
        userStatus = status
        super.init(nibName: Constants.kHomeStatusViewIdentifier, bundle: nil)
        if(userStatus == Constants.kPending) {
            presentPendingAlert()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.layer.cornerRadius = 10
        registerButton.clipsToBounds = true
        //        registerButton.layer.masksToBounds = true
        //view.backgroundColor = UIColor.sqGreenLight
        //view.layer.backgroundColor = UIColor.lightGray as! CGColor

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentPendingAlert() {
        let alertController = UIAlertController(title: "You have an invitation waiting.", message: "An existing team leader has invited you to join their team.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel) { action in
            // ...
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "I'm interested...", style: .default) { action in
            let newViewController = HookPageViewController()
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true) {
            // ...
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
