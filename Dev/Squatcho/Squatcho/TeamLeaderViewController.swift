//
//  TeamLeaderViewController.swift
//  Squatcho
//
//  Created by Alexandra Francis on 8/28/17.
//  Copyright © 2017 Marlexa. All rights reserved.
//

import UIKit

class TeamLeaderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var teamListTableView: UITableView!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBAction func addMember(_ sender: UIButton) {
        PymongoService.shared.getAllAvailableUsers() { emailList in
            for email in emailList {
                print(email)
            }
        }
    }
    
    var myTeamList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let teamName = SessionManager.shared.user?.teamName {
            teamNameLabel.text = teamName
        }
        PymongoService.shared.getMyTeam() { teamList in
            self.myTeamList = teamList
            self.teamListTableView.reloadData()
        }
        let nib = UINib(nibName: Constants.kTeamTableViewCellId, bundle: nil)
        teamListTableView.register(nib, forCellReuseIdentifier: Constants.kCellXibId)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myTeamList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.kCellXibId, for: indexPath) as! TeamTableViewCell
        cell.nameLabel.text = myTeamList[indexPath.row]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
