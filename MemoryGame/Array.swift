//
//  Array.swift
//  Pairs
//
//  Created by Punnaghai Puvi on 4/12/16.
//  Copyright © 2016 Punnaghai Puvi. All rights reserved.
//

import Foundation

extension Array {
    var shuffle:[Element] {
        var elements = self
        for index in 0..<elements.count {
            let newIndex = Int(arc4random_uniform(UInt32(elements.count-index)))+index
            if index != newIndex { // Check if you are not trying to swap an element with itself
                swap(&elements[index], &elements[newIndex])
            }
        }
        return elements
    }
}
