//
//  MenuController.swift
//  Squatcho
//
//  Created by Alexandra Francis on 7/19/17.
//  Copyright © 2017 Marlexa. All rights reserved.
//

import UIKit

struct MenuItem {
    var selected: Bool
    var text: String
}

class Menu {
    var items = [MenuItem(selected: false, text: ""), MenuItem(selected: true, text: "Home"), MenuItem(selected: false, text: "Team"), MenuItem(selected: false, text: "Map"), MenuItem(selected: false, text: "Details"), MenuItem(selected: false, text: "Account")]
    
    init() {
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: Constants.selectDetailsMenuItem), object: nil, queue: nil, using: selectDetails)
    }
    
    func selectDetails(notification:Notification) {
        for i in 0...items.count-1 {
            if items[i].selected {
                items[i].selected = false
            }
            if items[i].text == "Details" {
                items[i].selected = true
            }
        }
    }
}

class MenuController: UITableViewController {
    var menuItems = Menu()
    var width = CGFloat(45.0), height = CGFloat(45.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.sqGreen
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateView()
    }
    
    func updateView() {
        let selectedItem = menuItems.items.filter{$0.selected}[0]
        let selectedCell = tableView.visibleCells.filter{$0.textLabel?.text == selectedItem.text}[0]
        selectedCell.textLabel?.textColor = UIColor.sqSelected
        selectedCell.textLabel?.font = UIFont.systemFont(ofSize: (selectedCell.textLabel?.font.pointSize)!, weight: UIFontWeightBold)
        selectedCell.imageView?.image = (selectedCell.imageView?.image?.withRenderingMode(.alwaysTemplate))!
        selectedCell.imageView?.tintColor = UIColor.sqSelected
        selectedCell.imageView?.frame = CGRect(origin: CGPoint(x: 14, y: 2), size: CGSize(width: (width * 0.8), height: (height * 0.8)))
//        selectedCell.imageView?.frame.size = CGSize(width: (width * 0.8), height: (height * 0.8))

        let unselectedItems = menuItems.items.filter{!$0.selected}
        let _ = tableView.visibleCells.map {
            for item in unselectedItems {
                if item.text == $0.textLabel?.text {
                    $0.textLabel?.textColor = UIColor.sqUnselected
                    $0.textLabel?.font = UIFont.systemFont(ofSize: ($0.textLabel?.font.pointSize)!, weight: UIFontWeightRegular)
                    $0.imageView?.image = ($0.imageView?.image?.withRenderingMode(.alwaysTemplate))!
                    $0.imageView?.tintColor = UIColor.sqUnselected
                    $0.imageView?.frame = CGRect(origin: CGPoint(x: 17, y: 6), size: CGSize(width: (width * 0.6), height: (height * 0.6)))
//                    $0.imageView?.frame.size = CGSize(width: (width * 0.5), height: (height * 0.5))
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuItems.items.count
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.sqGreen
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            for i in 0...menuItems.items.count-1 {
                if menuItems.items[i].selected {
                    menuItems.items[i].selected = false
                }
                if menuItems.items[i].text == cell.textLabel?.text {
                    menuItems.items[i].selected = true
                }
            }
            updateView()
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
