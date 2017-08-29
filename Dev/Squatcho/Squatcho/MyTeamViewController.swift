//
//  MyTeamViewController
//  Squatcho
//
//  Created by Alexandra Francis on 7/19/17.
//  Copyright © 2017 Marlexa. All rights reserved.
//

import UIKit

class MyTeamViewController: UIViewController {
    @IBOutlet weak var menuButton:UIBarButtonItem!
    @IBOutlet weak var containerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        // Set up which home view controller to use
        var viewController: UIViewController
        if let status = SessionManager.shared.user?.userStatus {
            if status == Constants.kMember {
                viewController = TeamMemberViewController()
            } else if status == Constants.kLeader {
                viewController = TeamLeaderViewController()
            } else if status == Constants.kDuring {
                viewController = HookPageViewController()
            } else {
                viewController = HookPageViewController()
            }
        } else {
            viewController = HookPageViewController()
        }

        // Set up which home view controller to use
        addChildViewController(viewController)
        viewController.view.frame = CGRect(x: 0, y: -64, width: containerView.frame.size.width, height: containerView.frame.size.height+64)
        containerView.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
