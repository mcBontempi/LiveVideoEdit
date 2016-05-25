//
//  RecordViewController.swift
//  LiveVideoEdit
//
//  Created by Daren David Taylor on 24/05/2016.
//  Copyright © 2016 HolidayExtras. All rights reserved.
//

import UIKit
import PBJVision

class RecordViewController: UIViewController {

    @IBOutlet weak var previewView: UIView!
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    
    func createPreviewView() {
        self.previewLayer = PBJVision.sharedInstance().previewLayer
        
        self.previewLayer.backgroundColor = UIColor.blackColor().CGColor
        self.previewView.backgroundColor = UIColor.blackColor()
        
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.previewView.layer.addSublayer(self.previewLayer)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.createPreviewView()
        
    PBJVision.sharedInstance().startPreview()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
     
        
    }
    
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        
        let vision = PBJVision.sharedInstance()
        
        
        var visionOrientation:PBJCameraOrientation?
        
        
        switch(toInterfaceOrientation) {
            
        case .Unknown:
            visionOrientation =  .Portrait
        case .Portrait:
               visionOrientation =  .Portrait
        case .PortraitUpsideDown:
               visionOrientation =  .PortraitUpsideDown
        case .LandscapeLeft:
               visionOrientation = .LandscapeLeft
        case .LandscapeRight:
               visionOrientation = .LandscapeRight
            
        }
        
        
        vision.cameraOrientation = visionOrientation!
        
    }
    
    
    func updatePreviewLayer() {
        
        if let previewView = self.previewView {
            if let previewLayer = self.previewLayer {
                previewLayer.frame = previewView.frame
                
            }
        }
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.updatePreviewLayer()
    }
}
