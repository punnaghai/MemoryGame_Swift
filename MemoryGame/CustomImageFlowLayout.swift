//
//  CustomImageFlowLayout.swift
//  MemoryGame
//  Created to customize the flow layout by setting the images with the image size
//  Created by Punnaghai Puvi on 4/12/16.
//  Copyright © 2016 Punnaghai Puvi. All rights reserved.
//

import UIKit

class CustomImageFlowLayout: UICollectionViewFlowLayout {

    override init() {
        super.init()
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    //sets the minimum spacing between the cells
    func setupLayout() {
        minimumInteritemSpacing = 1
        minimumLineSpacing = 1
        scrollDirection = .Vertical
    }

}
