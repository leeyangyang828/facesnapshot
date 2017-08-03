//
//  processPoints.swift
//  MyFaceTracking
//
//  Created by Soto Yanis on 21/04/2016.
//  Copyright © 2016 Soto Yanis. All rights reserved.
//

import UIKit


class ProcessPoints {

    func processCenter(_ point1: CGPoint, point2: CGPoint) -> CGPoint {
        let center = CGPoint(x: (point1.x + point2.x) / 2, y: (point1.y + point2.y) / 2)
        return (center)
    }

    func processCornerDist(_ point1: CGPoint, point2: CGPoint) -> CGFloat {
        let cornerDist = sqrt(pow(point1.x - point2.x, 2) + pow(point1.y - point2.y, 2))
        return (cornerDist)
    }
    
    func processAngle(_ point1: CGPoint, point2: CGPoint) -> CGFloat {
        let angle = atan2(point2.y - point1.y, point2.x - point1.x)
        return (angle)
    }
    
    func setAnchorPoint(_ anchorPoint: CGPoint, forView view: UIView) {
        var newPoint = CGPoint(x: view.bounds.size.width * anchorPoint.x, y: view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: view.bounds.size.width * view.layer.anchorPoint.x, y: view.bounds.size.height * view.layer.anchorPoint.y)
        newPoint = newPoint.applying(view.transform)
        oldPoint = oldPoint.applying(view.transform)
        var position = view.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        position.y -= oldPoint.y
        position.y += newPoint.y
        view.layer.position = position
        view.layer.anchorPoint = anchorPoint
    }
}
