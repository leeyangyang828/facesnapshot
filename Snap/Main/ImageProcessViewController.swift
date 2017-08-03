//
//  ImageProcessViewController.swift
//  SnapFace
//
//  Created by WangChengGong on 6/14/17.
//  Copyright © 2017 WangChengGong. All rights reserved.
//

import UIKit
import DragDropiOS
import Photos
import PhotosUI

class ImageProcessViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, DragDropCollectionViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource {
    
    var models:[Model] = [Model]()
    var memedImage: UIImage!
    var dragDropManager:DragDropManager!
    var imageArray: NSMutableArray = ["mask_1.png","mask_2.png","mask_3.png","mask_4.png","mask_5.png",
                                        "mask_6.png","mask_7.png","mask_8.png","mask_9.png","mask_10.png"]
    
    @IBOutlet weak var imagePan: DragDropView!
    
    @IBOutlet weak var addPhotoBtn: UIButton!
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var infiniteCollectionView: DragDropCollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0 ..< 10 {
            let model = Model()
            model.index = i
            model.imageName = imageArray[i] as? String
            models.append(model)
        }
        
        imagePan.contentMode = .scaleAspectFill
        imagePan.clipsToBounds = true
        imagePan.layer.cornerRadius = 5
        
        let monkeyImgView = UIImageView(image: UIImage(named: "monkey.png"))
        let bananaImgView = UIImageView(image: UIImage(named: "banana.png"))
        
        monkeyImgView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        bananaImgView.frame = CGRect(x: 150, y: 150, width: 100, height: 100)
        
        
        monkeyImgView.isUserInteractionEnabled = true
        bananaImgView.isUserInteractionEnabled = true
        
        imagePan.addSubview(monkeyImgView)
        imagePan.addSubview(bananaImgView)
        
        let myHandlePanRecognizer1 = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        let myHandlePincheRecognizer1 = UIPinchGestureRecognizer(target: self, action: #selector(handlePinche))
        let myHandleRotateRecognizer1 = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate))
        
        monkeyImgView.addGestureRecognizer(myHandlePanRecognizer1)
        monkeyImgView.addGestureRecognizer(myHandlePincheRecognizer1)
        monkeyImgView.addGestureRecognizer(myHandleRotateRecognizer1)
        
        let myHandlePanRecognizer2 = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        let myHandlePincheRecognizer2 = UIPinchGestureRecognizer(target: self, action: #selector(handlePinche))
        let myHandleRotateRecognizer2 = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate))
        
        bananaImgView.addGestureRecognizer(myHandlePanRecognizer2)
        bananaImgView.addGestureRecognizer(myHandlePincheRecognizer2)
        bananaImgView.addGestureRecognizer(myHandleRotateRecognizer2)
        
        infiniteCollectionView.bounces = false
        infiniteCollectionView.dragDropDelegate = self
        
        dragDropManager = DragDropManager(canvas: self.view, views: [infiniteCollectionView, imagePan])
        
        let nib = UINib(nibName:"ExampleCollectionViewCell", bundle:nil);
        infiniteCollectionView.register(nib, forCellWithReuseIdentifier: "cellCollectionView")
        
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onMergeImages(_ sender: UIButton) {
        
        
        
        let layer = imagePan.layer
            //UIApplication.shared.keyWindow?.layer
        let scale = imagePan.contentScaleFactor
            //UIScreen.main.scale
        
        //UIGraphicsBeginImageContextWithOptions((layer?.frame.size)!, false, scale)
        UIGraphicsBeginImageContextWithOptions(imagePan.frame.size, false, scale)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenShot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
//        UIGraphicsBeginImageContext(imagePan.frame.size)
//        self.imagePan.drawHierarchy(in: imagePan.frame, afterScreenUpdates: true)
//        let screenShot: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
        
        UIImageWriteToSavedPhotosAlbum(screenShot!, nil, nil, nil)
        
        
//        let imagePicker = UIImagePickerController()
//        imagePicker.delegate = self
//        imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
//        imagePicker.allowsEditing = true
//        self.present(imagePicker, animated: true, completion: nil)
        

//        let activityItems = [screenShot]
//        let ac = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
//        
//        ac.completionWithItemsHandler = {(activitytype, completed: Bool, returnedItems, error) in
//            if completed {
//                //self.save()
//                self.dismiss(animated: true, completion: nil)
//            }
//        }
//        
//        present(ac, animated: true, completion: nil)
        
        let vc = ShareImageViewController()
        vc.zoomImage = screenShot
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    
    @IBAction func onGetPhoto(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    func openCamera()
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        addPhotoBtn.isHidden = true
        var  chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        chosenImage = appDelegate.resizeImage(image: chosenImage, targetSize: CGSize.init(width: 100, height: 100))
        
        
        let chosenImgView = UIImageView(image: chosenImage)
        
        chosenImgView.frame = CGRect(x: 150, y: 0, width: 100, height: 100)
        chosenImgView.isUserInteractionEnabled = true
        
        
        let myHandlePanRecognizer1 = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        let myHandlePincheRecognizer1 = UIPinchGestureRecognizer(target: self, action: #selector(handlePinche))
        let myHandleRotateRecognizer1 = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate))
        
        chosenImgView.addGestureRecognizer(myHandlePanRecognizer1)
        chosenImgView.addGestureRecognizer(myHandlePincheRecognizer1)
        chosenImgView.addGestureRecognizer(myHandleRotateRecognizer1)
        
        imagePan.addSubview(chosenImgView)
//        self.uploadPhoto(image: chosenImage)
        dismiss(animated:true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    
    
    
    func addImgToPan(model: Model, rect: CGRect){
        
        let addedImgView = UIImageView(image: UIImage(named: model.imageName!))
        
        addedImgView.frame = rect
        addedImgView.isUserInteractionEnabled = true
        
        
        let myHandlePanRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        let myHandlePincheRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinche))
        let myHandleRotateRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate))
        
        addedImgView.addGestureRecognizer(myHandlePanRecognizer)
        addedImgView.addGestureRecognizer(myHandlePincheRecognizer)
        addedImgView.addGestureRecognizer(myHandleRotateRecognizer)
        
        imagePan.addSubview(addedImgView)
        
    }
    
    
    
    
    func handlePan(recognizer:UIPanGestureRecognizer){
        
        let translation = recognizer.translation(in: self.imagePan)
        if let view = recognizer.view {
            view.center = CGPoint(x: view.center.x + translation.x,
                                  y:view.center.y + translation.y)
            
//            let alpha: CGFloat = CGFloat(sqrtf(powf(Float(translation.x), Float(translation.x)) + powf(Float(translation.y), Float(translation.y))) / sqrtf(powf(Float(view.center.x), Float(view.center.x)) + powf(Float(view.center.y), Float(view.center.y))))
//            
//            self.view.backgroundColor = UIColor(white: 1, alpha: 1/alpha)
        }
        
        
        
        
        recognizer.setTranslation(CGPoint.zero, in: self.imagePan)
        
        if recognizer.state == UIGestureRecognizerState.ended{
            let velocity = recognizer.velocity(in: self.view)
            let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
            let slideMultiplier = magnitude / 200
           // print("magnitude: \(magnitude), slideMultiplier: \(slideMultiplier)")
            
            let slideFactor = 0.1 * slideMultiplier //Increase for more of a slide
            
            var finalPoint = CGPoint(x:recognizer.view!.center.x + (velocity.x * slideFactor),
                                     y: recognizer.view!.center.y + (velocity.y * slideFactor))
            
            finalPoint.x = min(max(finalPoint.x, 0),self.view.bounds.size.width)
            finalPoint.y = min(max(finalPoint.y, 0), self.view.bounds.size.height)
            
            UIView.animate(withDuration: Double(slideFactor * 2), delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { recognizer.view!.center = finalPoint }, completion: nil)
        }
    }
    
    func handlePinche(recognizer: UIPinchGestureRecognizer){
        if let view = recognizer.view{
            view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
            recognizer.scale = 1
        }
    }
    
    func handleRotate(recognizer : UIRotationGestureRecognizer){
        if let view = recognizer.view {
            view.transform = view.transform.rotated(by: recognizer.rotation)
            recognizer.rotation = 0
        }
    }

    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = models[indexPath.item]
        
        let cell = infiniteCollectionView.dequeueReusableCell(withReuseIdentifier: "cellCollectionView", for: indexPath) as! ExampleCollectionViewCell
        //cell.lbTitle.text = cellItems[usableIndexPath.row]
        cell.updateData(model)
        return cell
    }
    
    // MARK : DragDropCollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, touchBeginAtIndexPath indexPath: IndexPath) {
        
        clearCellsDrogStatus()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, representationImageAtIndexPath indexPath: IndexPath) -> UIImage? {
        
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIGraphicsBeginImageContextWithOptions(cell.bounds.size, false, 0)
            cell.layer.render(in: UIGraphicsGetCurrentContext()!)
            
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return img
        }
        
        return nil
        
    }
    
    func collectionView(_ collectionView: UICollectionView, canDragAtIndexPath indexPath: IndexPath) -> Bool {
        
        return true
        //return models[indexPath.item].text != nil
        
    }
    func collectionView(_ collectionView: UICollectionView, dragInfoForIndexPath indexPath: IndexPath) -> AnyObject {
        
        
                let dragInfo = Model()
        
                dragInfo.index = indexPath.item
                dragInfo.imageName = models[indexPath.item].imageName
        
                return dragInfo
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, canDropWithDragInfo dataItem: AnyObject, AtIndexPath indexPath: IndexPath) -> Bool {
        
        let cell = collectionView.cellForItem(at: indexPath) as! ExampleCollectionViewCell
        cell.moveOverStatus()
        
        
        //        let dragInfo = dataItem as! Model
        //
        //        let overInfo = models[indexPath.item]
        //
        //        debugPrint("move over index: \(indexPath.item)")
        //
        //        //drag source is mouse over item（self）
        //        if indexPath.item == dragInfo.index && dragInfo.text == overInfo.text {
        //            return false
        //        }
        //
        //        clearCellsDrogStatus()
        //
        //        for cell in collectionView.visibleCells{
        //
        //            //update move over cell status
        //            if overInfo.index == (cell as! CollectionViewCell).model.index {
        //
        //                if overInfo.text == nil {
        //                    let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        //                    cell.moveOverStatus()
        //                    debugPrint("can drop in . index = \(indexPath.item)")
        //
        //                    return true
        //                }else{
        //                    debugPrint("can't drop in. index = \(indexPath.item)")
        //                }
        //
        //            }
        //
        //        }
        //
        //        return false
        return true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, dropOutsideWithDragInfo info: AnyObject) {
        clearCellsDrogStatus()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, dragCompleteWithDragInfo dragInfo:AnyObject, atDragIndexPath dragIndexPath: IndexPath,withDropInfo dropInfo:AnyObject?) -> Void{
        //        if (dropInfo != nil){
        //
        //            models[dragIndexPath.item].text = (dropInfo as! Model).text
        //            models[dragIndexPath.item].imageName = (dropInfo as! Model).imageName
        //        }else{
        //            models[dragIndexPath.item].text = nil
        //            models[dragIndexPath.item].imageName = nil
        //        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropCompleteWithDragInfo dragInfo:AnyObject, atDragIndexPath dragIndexPath: IndexPath?,withDropInfo dropInfo:AnyObject?,atDropIndexPath dropIndexPath:IndexPath) -> Void{
        
        
        debugPrint("can't drop in. index zvczxvczxcvzxcvzxcvxsdf")
       
        
        //        models[dropIndexPath.item].text = (dragInfo as! Model).text
        //        models[dropIndexPath.item].imageName = (dragInfo as! Model).imageName
        
    }
    
    
    func collectionViewStopDropping(_ collectionView: UICollectionView) {
        
        clearCellsDrogStatus()
        
        collectionView.reloadData()
    }
    
    func collectionViewStopDragging(_ collectionView: UICollectionView) {
        
        clearCellsDrogStatus()
        
        collectionView.reloadData()
        
    }
    
    
    func clearCellsDrogStatus(){
        
                for cell in infiniteCollectionView.visibleCells{
        
                    if (cell as! ExampleCollectionViewCell).hasContent() {
                        (cell as! ExampleCollectionViewCell).selectedStatus()
                        continue
                    }
        
                    (cell as! ExampleCollectionViewCell).nomoralStatus()
        
        
                }
        
    }


}


