//
//  SessionHandler.swift
//  DisplayLiveSamples
//
//  Created by Luis Reisewitz on 15.05.16.
//  Copyright © 2016 ZweiGraf. All rights reserved.
//

import AVFoundation
import Foundation
import UIKit

class SessionHandler : NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureMetadataOutputObjectsDelegate {
    var session = AVCaptureSession()
    let layer = AVSampleBufferDisplayLayer()
    let sampleQueue = DispatchQueue(label: "com.zweigraf.DisplayLiveSamples.sampleQueue", attributes: [])
    let faceQueue = DispatchQueue(label: "com.zweigraf.DisplayLiveSamples.faceQueue", attributes: [])
    let wrapper = DlibWrapper()
    var devicePosition: Int = 0
    var device: AVCaptureDevice! = nil
    var arrPoint: [CGPoint] = []
    var arrGroupPoint: [[CGPoint]] = [[]]
    var faceCounts: NSInteger = 0
    
    var currentMetadata: [AnyObject]
    
    override init() {
        currentMetadata = []
        super.init()
    }
    
    func swapCamera(){

        //session.stopRunning()
        //openSession()
        
//        session.stopRunning()
//        
//        if (devicePosition == 0){
//            devicePosition = 1
//            
//        }else{
//            devicePosition = 0
//        }
//        openSession()
    }
    
    func openSession() {
        
//        if (devicePosition == 1){
//            device = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back)
//            
//        }else{
            device = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
                .map { $0 as! AVCaptureDevice }
                .filter { $0.position == .front}
                .first!
//        }
    
        
        let input = try! AVCaptureDeviceInput(device: device)
        
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: sampleQueue)
        
        let metaOutput = AVCaptureMetadataOutput()
        metaOutput.setMetadataObjectsDelegate(self, queue: faceQueue)
    
        session.beginConfiguration()
        
        if session.canAddInput(input) {
            session.addInput(input)
        }
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        if session.canAddOutput(metaOutput) {
            session.addOutput(metaOutput)
        }
        
        session.commitConfiguration()
        
        let settings: [AnyHashable: Any] = [kCVPixelBufferPixelFormatTypeKey as AnyHashable: Int(kCVPixelFormatType_32BGRA)]
        output.videoSettings = settings
    
        // availableMetadataObjectTypes change when output is added to session.
        // before it is added, availableMetadataObjectTypes is empty
        metaOutput.metadataObjectTypes = [AVMetadataObjectTypeFace]
        
        wrapper?.prepare()
        
        session.startRunning()
    }
    
    // MARK: AVCaptureVideoDataOutputSampleBufferDelegate
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        
        connection.videoOrientation = AVCaptureVideoOrientation.portrait
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        if !currentMetadata.isEmpty {
            let boundsArray = currentMetadata
                .flatMap { $0 as? AVMetadataFaceObject }
                .map { (faceObject) -> NSValue in
                    let convertedObject = captureOutput.transformedMetadataObject(for: faceObject, connection: connection)
                    //print(faceObject)
                    return NSValue(cgRect: convertedObject!.bounds)
            }
            wrapper?.doWork(on: sampleBuffer, inRects: boundsArray)
            
            
            DispatchQueue.main.async {

                appDelegate.cameraFilterController?.faceTrackerDidUpdate((self.wrapper?.getPoints())!, faceCounts: (self.wrapper?.getFaceCounts())!)
                
            }
            
            

        }else{
            appDelegate.cameraFilterController?.hideAllView()
        }
        
        layer.enqueue(sampleBuffer)
        
        
        
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didDrop sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.cameraFilterController?.hideAllView()
        //print("DidDropSampleBuffer")
    }
    
    // MARK: AVCaptureMetadataOutputObjectsDelegate
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.cameraFilterController?.hideAllView()
        currentMetadata = metadataObjects as [AnyObject]
        //print(currentMetadata)
    }
}
