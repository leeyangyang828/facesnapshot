//
//  CameraFilterViewController.swift
//  Snap
//
//  Created by WangChengGong on 6/17/17.
//  Copyright © 2017 WangChengGong. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftGifOrigin


class CameraFilterViewController: UIViewController, UIScrollViewDelegate {
    
    let filter = Filter()
    var buttonList = [UIButton]()
    var screenShot = UIImage()
    
    /* State filter */
    var stateFilter: NSString = ""
    
    /* View for Filter */
    var eyeView = [UIImageView]()
    
    var subView1 = UIImageView()
    var subView2 = UIImageView()

    /* End */
    
    
    let sessionHandler = SessionHandler()
    

    @IBOutlet weak var preview: UIView!
    
    @IBOutlet weak var swapButton: UIButton!
    
    @IBOutlet weak var photoButton: UIButton!

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var activatePhoto: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.stateFilter = "mask_1.png";
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        sessionHandler.openSession()
        
        
        let layer = sessionHandler.layer
        layer.frame = preview.bounds
        
        preview.layer.addSublayer(layer)
        
        //view.layoutIfNeeded()
        
    }
    func hideElement() {
        for button in self.buttonList{
            button.isHidden = true
        }
        self.swapButton.isHidden = true
        self.photoButton.isHidden = true
    }
    
    @IBAction func photoAction(_ sender: UIButton) {
        self.hideElement()
    }
    
    
    func faceTrackerDidUpdate(_ cgpoints: UnsafeMutablePointer<UnsafeMutablePointer<CGPoint>?>, faceCounts: NSInteger) {
        
        hideAllView()
        
        var points: [[CGPoint]] = [[]]
 
        
        points = [[CGPoint]](repeating:[CGPoint](repeating:CGPoint(x: 0.0, y: 0.0), count:12), count:faceCounts)
        
        
        for i in 0...faceCounts-1{

            for j in 0...11{
                points[i][j].x = (cgpoints[i]![j].x)
                points[i][j].y = (cgpoints[i]![j].y)
                
            }
            
            eyeView.append(filter.drawMask(points[i], mask: self.stateFilter as String))
            self.view.addSubview(eyeView[i])
            
        }
    
        
        

    }
    
    func hideAllView() {
        
       
        eyeView.forEach({
            $0.removeFromSuperview();
            $0.isHidden = true;
        })
        eyeView.removeAll()


    }
    
    
    
    @IBAction func swapAction(_ sender: UIButton) {
        
        sessionHandler.swapCamera()
//        sessionHandler.openSession()
//        
//        
//        let layer = sessionHandler.layer
//        layer.frame = preview.bounds
//        
//        preview.layer.addSublayer(layer)
//        
//        view.layoutIfNeeded()
        
        
    }
    /* Create Button, fill it */
    func createButton() {
        let imageArray = fillImageArray()
        var lastButtonWidth: CGFloat = 0
        
        photoButton.backgroundColor = UIColor.darkGray.withAlphaComponent(0.8)
        photoButton.layer.cornerRadius = 0.45 * photoButton.bounds.size.width
        photoButton.layer.borderWidth = 4
        photoButton.layer.borderColor = UIColor.white.cgColor
        
        for index in 0..<10 {
            let frame1 = CGRect(x: ((self.view.frame.size.width / 2) - 27.5) + CGFloat(index * 70), y: 0, width: 55, height: 55 )
            let button = UIButton(frame: frame1)
            button.setImage(imageArray[index], for: UIControlState())
            button.tag = index
            button.addTarget(self, action: #selector(CameraFilterViewController.buttonClicked(_:)), for: .touchUpInside)
            self.scrollView.addSubview(button)
            lastButtonWidth = frame1.origin.x
            buttonList.append(button)

        }
        self.scrollView.contentSize = CGSize(width: lastButtonWidth + 55, height: 0)
    }
    
    func buttonClicked(_ sender:UIButton)
    {
        let tag = sender.tag
        scrollAnimated(sender.frame.origin.x, y: sender.frame.origin.y)
        switch tag {
        case 0:
            self.stateFilter = "mask_1.png"
        case 1:
            self.stateFilter = "mask_2.png"
        case 2:
            self.stateFilter = "mask_3.png"
        case 3:
            self.stateFilter = "mask_4.png"
        case 4:
            self.stateFilter = "mask_5.png"
        case 5:
            self.stateFilter = "mask_6.png"
        case 6:
            self.stateFilter = "mask_7.png"
        case 7:
            self.stateFilter = "mask_8.png"
        case 8:
            self.stateFilter = "mask_9.png"
        case 9:
            self.stateFilter = "mask_10.png"
        default:
            print("No button selected")
        }
    }
    
    func scrollAnimated (_ x: CGFloat, y: CGFloat) {
        let centerScrollView = scrollView.frame.size.height * 2 - 7.5
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
            self.scrollView.contentOffset = CGPoint(x: x - centerScrollView, y: y)
        }, completion: nil)
    }
    
    @IBAction func screenshotEmbed(_ sender: UIButton) {
        
        let vc = ScreenShotViewController()
        vc.toPass = captureScreen()
        self.hideElement()
        self.navigationController?.present(vc, animated: true)
        
        
    }
    
}


