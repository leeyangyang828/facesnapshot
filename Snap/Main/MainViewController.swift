//
//  MainViewController.swift
//  Snap
//
//  Created by WangChengGong on 6/17/17.
//  Copyright © 2017 WangChengGong. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    
    
    @IBAction func toImageProcess(_ sender: UIButton) {
        
        
        
        
        let vc = ImageProcessViewController()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.imageProcessController = vc

        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func toCameraFilter(_ sender: UIButton) {
        
        let vc = CameraFilterViewController()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.cameraFilterController = vc

        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
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
