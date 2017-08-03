//
//  ShareImageViewController.swift
//  Snap
//
//  Created by WangChengGong on 6/16/17.
//  Copyright © 2017 WangChengGong. All rights reserved.
//

import UIKit

class ShareImageViewController: UIViewController {
    
    var zoomImage: UIImage!

    @IBOutlet weak var zoomImageView: UIImageView!
    
    
    @IBOutlet weak var zoomScrollView: UIScrollView!
    
    @IBOutlet weak var shareBtn: UIButton!
    
    @IBAction func onShareImage(_ sender: UIButton) {
    }
    
    @IBOutlet weak var shareBackgound: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
