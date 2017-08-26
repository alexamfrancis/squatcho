//
//  CountdownViewController.swift
//  Squatcho
//
//  Created by Alexandra Francis on 8/17/17.
//  Copyright © 2017 Marlexa. All rights reserved.
//

import UIKit

class CountdownViewController: UIViewController {
    @IBOutlet weak var moreInfoButton: UIButton!
    @IBAction func tappedMoreInfo(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let detailVC: DetailsViewController = storyboard.instantiateViewController(withIdentifier: Constants.detailsViewControllerIdentifier) as! DetailsViewController
        self.navigationController?.pushViewController(detailVC, animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.selectDetailsMenuItem), object: nil)
    }
    
    init() {
        super.init(nibName: Constants.kCountdownViewIdentifier, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        moreInfoButton.layer.cornerRadius = 8
        moreInfoButton.clipsToBounds = true

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
