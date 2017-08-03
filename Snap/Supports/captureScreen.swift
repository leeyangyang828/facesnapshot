//
//  captureScreen.swift
//  MyFaceTracking
//
//  Created by Soto Yanis on 28/04/2016.
//  Copyright © 2016 Soto Yanis. All rights reserved.
//

import UIKit


func captureScreen() -> UIImage {
    
    
    var window: UIWindow? = UIApplication.shared.keyWindow
    window = UIApplication.shared.windows[0]
    UIGraphicsBeginImageContextWithOptions(window!.frame.size, window!.isOpaque, 0.0)
    window!.layer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!;
    
    
//    let layer = UIApplication.shared.keyWindow?.layer
//    let scale = UIScreen.main.scale
//    
//    UIGraphicsBeginImageContextWithOptions((layer?.frame.size)!, false, scale)
//    layer?.render(in: UIGraphicsGetCurrentContext()!)
//    let screenShot = UIGraphicsGetImageFromCurrentImageContext()
//    UIGraphicsEndImageContext()
//    
//    return screenShot!;
}
