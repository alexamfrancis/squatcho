//
//  HomeViewController.swift
//  Squatcho
//
//  Created by Alexandra Francis on 7/19/17.
//  Copyright © 2017 Marlexa. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIImagePickerControllerDelegate {
    @IBOutlet weak var menuButton:UIBarButtonItem!
    @IBOutlet weak var locationTitleBar: UINavigationItem!
    @IBOutlet weak var containerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // Set up which home view controller to use
        let viewController = HomeStatusViewController(with: Constants.kNull)
        addChildViewController(viewController)
        viewController.view.frame = CGRect(x: 0, y: 0, width: containerView.frame.size.width, height: containerView.frame.size.height)
        containerView.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 86.0, height: 20.0))
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        
        locationTitleBar.titleView = imageView
        locationTitleBar.titleView?.contentMode = .center
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
//    func openCameraButton(sender: AnyObject) {
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
//            var imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
//            imagePicker.allowsEditing = false
//            self.present(imagePicker, animated: true, completion: nil)
//        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    


}
