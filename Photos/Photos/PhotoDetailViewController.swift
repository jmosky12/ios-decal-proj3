//
//  PhotoDetailViewController.swift
//  Photos
//
//  Created by Jake Moskowitz on 11/17/15.
//  Copyright © 2015 iOS DeCal. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {

    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likedButton: UIButton!
    @IBOutlet weak var photoIV: UIImageView!
    let photo: Photo!
    let blue = UIColor(red: 102.0/255.0, green: 204.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    
    init(photo: Photo) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameLabel.text = photo.username
        likedButton.titleLabel?.text = "\(photo.likes)"
        let unixTime = Double(photo.date!)
        let date = NSDate(timeIntervalSince1970: unixTime!)
        let calendar = NSCalendar.currentCalendar()
        let month = calendar.component(NSCalendarUnit.Month, fromDate: date)
        let day = calendar.component(NSCalendarUnit.Day, fromDate: date)
        let year = calendar.component(NSCalendarUnit.Year, fromDate: date)
        dateLabel.text = "\(month)/\(day)/\(year)"
        likesLabel.text = "\(photo.likes)"
        
        let photoURL: NSURL = NSURL(string: photo.url)!
        var task = NSURLSession.sharedSession().dataTaskWithURL(photoURL) { (data, response, error) -> Void in
            if error == nil {
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        let img = UIImage(data: data!)
                        self.photoIV.image = img
                    }
                }
            }
        }
        task.resume()
        
        likedButton.layer.cornerRadius = 5.0
        if photo.liked == true {
            likedButton.backgroundColor = blue
        } else {
            likedButton.backgroundColor = UIColor.lightGrayColor()
        }
        
        //ACCESS PHOTO PROPS FOR LABELS
        
        usernameLabel.text = "\(usernameLabel.text!)"
        dateLabel.text = "\(dateLabel.text!)"
    }

    @IBAction func likedPressed(sender: AnyObject) {
        if photo.liked == true {
            photo.liked = false
            photo.likes = photo.likes - 1
            likedButton.backgroundColor = UIColor.lightGrayColor()
        } else {
            photo.liked = true
            photo.likes = photo.likes + 1
            likedButton.backgroundColor = blue
        }
        likesLabel.text = "\(photo.likes)"
    }


}
