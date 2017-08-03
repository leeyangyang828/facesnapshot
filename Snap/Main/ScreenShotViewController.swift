//
//  ScreenShotViewController.swift
//  Snap
//
//  Created by WangChengGong on 6/19/17.
//  Copyright © 2017 WangChengGong. All rights reserved.
//

import UIKit

class ScreenShotViewController: UIViewController {

    @IBOutlet weak var screenshotView: UIImageView!
    var originalScreenshot = UIImageView()
    var toPass = UIImage()
    
    
    /* Draw part */
    var lastPoint:CGPoint!
    var isSwiping:Bool!
    var red:CGFloat!
    var green:CGFloat!
    var blue:CGFloat!
    
    @IBOutlet weak var redButton: UIButton!
    
    @IBOutlet weak var blueButton: UIButton!
    
    @IBOutlet weak var greenButton: UIButton!
    
    @IBOutlet weak var yellowButton: UIButton!
    
    @IBOutlet weak var pinkButton: UIButton!
    
    
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.screenshotView.image = self.toPass

        originalScreenshot.image = toPass
        
        redButton.backgroundColor = UIColor.red
        blueButton.backgroundColor = UIColor.blue
        greenButton.backgroundColor = UIColor.green
        yellowButton.backgroundColor = UIColor.yellow
        pinkButton.backgroundColor = UIColor.black
        
        red   = (0.0/255.0)
        green = (0.0/255.0)
        blue  = (0.0/255.0)
        
        redButton.layer.cornerRadius = 0.441 * redButton.bounds.size.width
        blueButton.layer.cornerRadius = 0.441 * blueButton.bounds.size.width
        greenButton.layer.cornerRadius = 0.441 * greenButton.bounds.size.width
        yellowButton.layer.cornerRadius = 0.441 * yellowButton.bounds.size.width
        pinkButton.layer.cornerRadius = 0.441 * pinkButton.bounds.size.width
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func savePhoto(_ sender: UIButton) {
        UIImageWriteToSavedPhotosAlbum(screenshotView.image!, self, #selector(ScreenShotViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        if error == nil {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        }
    }
    @IBAction func shareAction(_ sender: UIButton) {
        let myShare = "My photo"
        let image = screenshotView.image
        
        let shareVC: UIActivityViewController = UIActivityViewController(activityItems: [(image)!, myShare], applicationActivities: nil)
        self.present(shareVC, animated: true, completion: nil)
    }
    /* Draw on image */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        isSwiping = false
        if let touch = touches.first{
            lastPoint = touch.location(in: screenshotView)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?){
        isSwiping = true;
        if let touch = touches.first{
            let currentPoint = touch.location(in: screenshotView)
            UIGraphicsBeginImageContext(self.screenshotView.frame.size)
            self.screenshotView.image?.draw(in: CGRect(x: 0, y: 0, width: self.screenshotView.frame.size.width, height: self.screenshotView.frame.size.height))
            UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
            UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: currentPoint.x, y: currentPoint.y))
            UIGraphicsGetCurrentContext()?.setLineCap(CGLineCap.round)
            UIGraphicsGetCurrentContext()?.setLineWidth(9.0)
            UIGraphicsGetCurrentContext()?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
            UIGraphicsGetCurrentContext()?.strokePath()
            self.screenshotView.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        if(!isSwiping) {
            // This is a single touch, draw a point
            UIGraphicsBeginImageContext(self.screenshotView.frame.size)
            self.screenshotView.image?.draw(in: CGRect(x: 0, y: 0, width: self.screenshotView.frame.size.width, height: self.screenshotView.frame.size.height))
            UIGraphicsGetCurrentContext()?.setLineCap(CGLineCap.round)
            UIGraphicsGetCurrentContext()?.setLineWidth(9.0)
            UIGraphicsGetCurrentContext()?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
            UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
            UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
            UIGraphicsGetCurrentContext()?.strokePath()
            self.screenshotView.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
    }
    @IBAction func undoAction(_ sender: UIButton) {
        screenshotView.image = originalScreenshot.image
    }
    @IBAction func redAction(_ sender: UIButton) {
        red   = (255.0/255.0)
        green = (0.0/255.0)
        blue  = (0.0/255.0)

    }
    @IBAction func blueAction(_ sender: UIButton) {
        red   = (0.0/255.0)
        green = (0.0/255.0)
        blue  = (255.0/255.0)
    }
    @IBAction func greenAction(_ sender: UIButton) {
        red   = (0.0/255.0)
        green = (255.0/255.0)
        blue  = (0.0/255.0)
    }
    @IBAction func yellowAction(_ sender: UIButton) {
        red   = (255.0/255.0)
        green = (255.0/255.0)
        blue  = (0.0/255.0)
    }
    
    
    @IBAction func pinkAction(_ sender: UIButton) {
        red   = (0.0/255.0)
        green = (0.0/255.0)
        blue  = (0.0/255.0)
    }
    
    @IBAction func cameraFilterView(_ sender: UIButton) {
        let vc = CameraFilterViewController()
        self.navigationController?.present(vc, animated: true)
    }
    
}
