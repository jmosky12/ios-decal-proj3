//
//  PhotosCollectionViewCell.swift
//  Photos
//
//  Created by Jake Moskowitz on 11/17/15.
//  Copyright © 2015 iOS DeCal. All rights reserved.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var photo: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        photo.contentMode = .ScaleAspectFit
        photo.clipsToBounds = true
        self.backgroundColor = UIColor.blackColor()
    }

}
