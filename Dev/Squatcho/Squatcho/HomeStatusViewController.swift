//
//  HomeNullViewController.swift
//  
//
//  Created by Alexandra Francis on 7/24/17.
//
//

import UIKit

class HomeStatusViewController: UIViewController {
    var userStatus: UserStatus
    
    init(with status: UserStatus) {
        userStatus = status
        switch userStatus {
        case .null:
            super.init(nibName: Constants.homeNullViewIdentifier, bundle: nil)
        case .leader: // UPDATE
            super.init(nibName: Constants.homeNullViewIdentifier, bundle: nil)
        case .member: // UPDATE
            super.init(nibName: Constants.homeNullViewIdentifier, bundle: nil)
        case .pending: // UPDATE
            super.init(nibName: Constants.homeNullViewIdentifier, bundle: nil)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.layer.backgroundColor = UIColor.lightGray as! CGColor

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