//
//  PhotosCollectionViewController.swift
//  Photos
//
//  Created by Gene Yoo on 11/3/15.
//  Copyright © 2015 iOS DeCal. All rights reserved.
//

import UIKit

class PhotosCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var photos: [Photo]!

    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.photos = [Photo]()
        let api = InstagramAPI()
        api.loadPhotos(didLoadPhotos)
        
        let nib: UINib = UINib(nibName: "PhotosCollectionViewCell", bundle: nil)
        self.collectionView?.registerNib(nib, forCellWithReuseIdentifier: "photoCell")
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photoCell", forIndexPath: indexPath) as! PhotosCollectionViewCell
        let photo = cell.photo
        loadImageForCell(photos[indexPath.row], imageView: photo)
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vc = PhotoDetailViewController(photo: photos[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = UIScreen.mainScreen().bounds.size.width * 0.48
        let height = UIScreen.mainScreen().bounds.size.height * 0.33
        return CGSizeMake(width, height)
    }

    
    /* Creates a session from a photo's url to download data to instantiate a UIImage. 
       It then sets this as the imageView's image. */
    func loadImageForCell(photo: Photo, imageView: UIImageView) {
        let photoURL: NSURL = NSURL(string: photo.url)!
        var task = NSURLSession.sharedSession().dataTaskWithURL(photoURL) { (data, response, error) -> Void in
            if error == nil {
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        let img = UIImage(data: data!)
                        imageView.image = img
                    }
                }
            }
        }
        task.resume()
    }
    
    /* Completion handler for API call. DO NOT CHANGE */
    func didLoadPhotos(photos: [Photo]) {
        self.photos = photos
        self.collectionView!.reloadData()
    }
    
}

