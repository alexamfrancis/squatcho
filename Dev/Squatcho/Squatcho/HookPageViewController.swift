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
        dismiss(animated: true, completion: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let detailVC: DetailsViewController = storyboard.instantiateViewController(withIdentifier: Constants.detailsViewControllerIdentifier) as! DetailsViewController
        show(detailVC, sender: nil)
        NotificationCenter.default.post(name:Notification.Name(rawValue: Constants.selectDetailsMenuItem), object: nil, userInfo: nil)

//        self.navigationController?.popToViewController(detailVC, animated: true)
//        _ = navigationController?.popToRootViewController(animated: true)
//        performSegue(withIdentifier: Constants.showDetailsVCSegueID, sender: nil)
    }
    @IBAction func tappedCreateNew(_ sender: Any) {
        UIApplication.shared.open(NSURL(string:"http://www.squatcho.com/")! as URL, options: [:], completionHandler: nil)
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
        imageOverlay.frame = screenSize
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
