//
//  HookPageViewController.swift
//  Squatcho
//
//  Created by Alexandra Francis on 8/2/17.
//  Copyright © 2017 Marlexa. All rights reserved.
//

import UIKit

class HookPageViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imageOverlay: UILabel!
    @IBOutlet weak var createNewButton: UIButton!
    @IBOutlet weak var joinExistingButton: UIButton!
    @IBOutlet weak var moreInfoButton: UIButton!
    @IBAction func tappedMoreInfo(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let detailVC: DetailsViewController = storyboard.instantiateViewController(withIdentifier: Constants.detailsViewControllerIdentifier) as! DetailsViewController
        self.navigationController?.pushViewController(detailVC, animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.selectDetailsMenuItem), object: nil)
    }
    
    @IBAction func tappedCreateNew(_ sender: Any) {
        UIApplication.shared.open(NSURL(string:"http://www.squatcho.com/")! as URL, options: [:], completionHandler: nil)
    }
    @IBAction func tappedJoinExisting(_ sender: UIButton) {
        if let status = SessionManager.shared.user?.userStatus, status == Constants.kPending {
            if let team = SessionManager.shared.user?.teamName {
                presentJoinAlert(team: team)
            } else {
                presentJoinAlert(team: "UNKNOWN_TEAM_NAME")
            }
        } else {
            presentNoInvitationAlert()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNewButton.layer.cornerRadius = 8
        createNewButton.clipsToBounds = true
        joinExistingButton.layer.cornerRadius = 8
        joinExistingButton.clipsToBounds = true
        moreInfoButton.layer.cornerRadius = 8
        moreInfoButton.clipsToBounds = true

        let screenSize = UIScreen.main.bounds
        image.frame = screenSize
        imageOverlay.frame = CGRect(x: -screenSize.width, y: 0, width: screenSize.width * 2, height: screenSize.height)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentJoinAlert(team: String) {
        let alertController = UIAlertController(title: "Join \(team).", message: "Click join to become a part of this team.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            // ...
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Join \(team)", style: .default) { action in
            PymongoService.shared.acceptInvitation()
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let teamVC = storyboard.instantiateViewController(withIdentifier: Constants.kMyTeamViewControllerIdentifier) as! MyTeamViewController
            self.navigationController?.pushViewController(teamVC, animated: true)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.selectTeamMenuItem), object: nil)

        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true) {
            // ...
        }
    }

    func presentNoInvitationAlert() {
        let alertController = UIAlertController(title: "You don't have any invitations.", message: "A team leader must invite you to join their team or you can create your own team!", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel) { action in
            // ...
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Create My Own Team", style: .default) { action in
            UIApplication.shared.open(NSURL(string:"http://www.squatcho.com/")! as URL, options: [:], completionHandler: nil)
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
