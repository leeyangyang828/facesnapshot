//
//  fillImageButton.swift
//  MyFaceTracking
//
//  Created by Soto Yanis on 20/04/2016.
//  Copyright © 2016 Soto Yanis. All rights reserved.
//

import UIKit


func fillImageArray () -> [Int: UIImage] {
    var imageArray = [Int: UIImage]()
    
    var temp: NSString = ""
    
    for index in 0...10{
        temp = "mask_\(index+1).png" as NSString
        imageArray[index] = UIImage(named: temp as String)
    }

    return (imageArray)
}
