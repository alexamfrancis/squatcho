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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
