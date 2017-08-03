//
//  filterClass.swift
//  MyFaceTracking
//
//  Created by Soto Yanis on 20/04/2016.
//  Copyright © 2016 Soto Yanis. All rights reserved.
//

import UIKit
import SwiftGifOrigin


class Filter {
    
    
    let processPoint = ProcessPoints()
    
    
    func drawMask(_ points: [CGPoint], mask: String) -> UIImageView {

        let eye =  UIImageView()
        
        let image = UIImage(named: mask)
        eye.image = image
        
        let centerEye: CGPoint = processPoint.processCenter(points[0], point2: points[9])
        let eyeCornerDist: CGFloat = processPoint.processCornerDist(points[0], point2: points[9])
        let eyeWidth: CGFloat = 2.0 * eyeCornerDist
        let eyeHeight: CGFloat = (eye.image!.size.height / eye.image!.size.width) * eyeWidth
        
        eye.transform = CGAffineTransform.identity
        
        if (mask == "mask_4.png"){
            eye.frame = CGRect(x: centerEye.x - eyeWidth / 2.3, y: centerEye.y - eyeWidth / 2.1, width: eyeWidth, height: eyeHeight)
        }else if (mask == "mask_5.png"){
            eye.frame = CGRect(x: centerEye.x - eyeWidth / 1.9, y: centerEye.y - eyeWidth / 2.1, width: eyeWidth, height: eyeHeight)
        }else if (mask == "mask_1.png"){
            eye.frame = CGRect(x: centerEye.x - eyeWidth / 2, y: centerEye.y - eyeWidth / 2, width: eyeWidth, height: eyeHeight)
        }else if (mask == "mask_2.png"){
            eye.frame = CGRect(x: centerEye.x - eyeWidth / 2, y: centerEye.y - eyeWidth / 2, width: eyeWidth, height: eyeHeight)
        }else if (mask == "mask_6.png"){
            eye.frame = CGRect(x: centerEye.x - eyeWidth / 1.9, y: centerEye.y - eyeWidth / 2.1, width: eyeWidth, height: eyeHeight)
        }else if(mask == "mask_8.png") {
            eye.frame = CGRect(x: centerEye.x - eyeWidth / 2, y: centerEye.y - eyeWidth / 1.5, width: eyeWidth, height: eyeHeight)
        }else if (mask == "mask_9.png"){
            eye.frame = CGRect(x: centerEye.x - eyeWidth / 2.3, y: centerEye.y - eyeWidth / 2, width: eyeWidth, height: eyeHeight)
        }else if (mask == "mask_10.png"){
            eye.frame = CGRect(x: centerEye.x - eyeWidth / 2, y: centerEye.y - eyeWidth / 1.7, width: eyeWidth, height: eyeHeight)
        }else{
            eye.frame = CGRect(x: centerEye.x - eyeWidth / 1.9, y: centerEye.y - eyeWidth / 1.9, width: eyeWidth, height: eyeHeight)
        }
        eye.isHidden = false
        processPoint.setAnchorPoint(CGPoint(x: 0.5, y: 1.0), forView:  eye)
        eye.transform = CGAffineTransform(rotationAngle: processPoint.processAngle(points[0], point2: points[9]))
    
        return ( eye)
    }
    
  
}
