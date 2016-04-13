//
//  FlickrImageCell.swift
//  MemoryGame
//
//  Created by Punnaghai Puvi on 4/12/16.
//  Copyright © 2016 Punnaghai Puvi. All rights reserved.
//

import UIKit

class FlickrImageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIView!
    var backImage: UIImageView!
    var frontImage: UIImageView!
    var picDetails:FlickrPhoto!
    var showingBack = true
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        backImage = nil
        frontImage = nil
        picDetails = nil
        showingBack = true
    }
    
    internal func configure(image:FlickrPhoto) {
        
        picDetails = image
        frontImage = UIImageView(image: picDetails.image)
        backImage = UIImageView(image:self.getImageWithColor(UIColor.redColor(), size: imageView.bounds.size))
        imageView.addSubview(backImage)
      
    }
    
    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func imageTouched(){
        if (showingBack) {
            UIView.transitionFromView(backImage, toView: frontImage!, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            showingBack = false
            
        } else {
            UIView.transitionFromView(frontImage!, toView: backImage, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
            showingBack = true
        }
        
    }
}