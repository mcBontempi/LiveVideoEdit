//
//  RecordViewController.swift
//  LiveVideoEdit
//
//  Created by Daren David Taylor on 24/05/2016.
//  Copyright © 2016 HolidayExtras. All rights reserved.
//

import UIKit
import PBJVision
import LSRepeater

class RecordViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    var urlToPass:NSURL!
    
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var recordButton: UIView!
    
    var started:Bool = false
    var recording:Bool = false
    
    var repeater: LSRepeater!
    
    override func shouldAutorotate() -> Bool {
        return !self.started
    }
    
    func colorBorder(color: UIColor) {
        self.previewView.layer.borderColor = color.CGColor
        self.previewView.layer.borderWidth = 4
        
    }
    
    func hideBorder() {
        self.previewView.layer.borderWidth = 0
    }
    
    @IBAction func longPressPressed(gestureRecognizer: UILongPressGestureRecognizer) {
        switch (gestureRecognizer.state) {
        case .Began:
            if self.recording == false {
                self.recording = true
                PBJVision.sharedInstance().startVideoCapture()
                self.colorBorder(UIColor.blueColor())
                print ("start")
            }
            else {
                PBJVision.sharedInstance().resumeVideoCapture()
                self.colorBorder(UIColor.blueColor())
                print ("resume")
            }
        case .Ended, .Cancelled, .Failed:
            PBJVision.sharedInstance().pauseVideoCapture()
            self.colorBorder(UIColor.redColor())
            print ("pause")
        default:
            break;
        }
    }
    
    @IBAction func startStopPressed(sender: AnyObject) {
        if self.started == false {
            
            self.view.userInteractionEnabled = false
            
            PBJVision.sharedInstance().startVideoCapture()
                PBJVision.sharedInstance().pauseVideoCapture()
                
                self.view.userInteractionEnabled = true

                self.recording = true
                self.started = true
                self.colorBorder(UIColor.redColor())
                self.recordButton.hidden = false
   }
        else {
            PBJVision.sharedInstance().endVideoCapture()
            self.recording = false
        }
    }
    
    @IBOutlet weak var previewView: UIView!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    func createPreviewView() {
        self.previewLayer = PBJVision.sharedInstance().previewLayer
        self.previewLayer.backgroundColor = UIColor.blackColor().CGColor
        self.previewView.backgroundColor = UIColor.blackColor()
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.previewView.layer.addSublayer(self.previewLayer)
    }
    
    func roundASquareViewOff(view:UIView) {
        
        let sideLength = view.frame.size.height
        view.layer.cornerRadius = sideLength/2
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PBJVision.sharedInstance().delegate = self
        self.createPreviewView()
        PBJVision.sharedInstance().startPreview()
        
        let vision = PBJVision.sharedInstance()
        
        vision.captureSessionPreset = AVCaptureSessionPreset1920x1080
        
        vision.cameraMode = .Video;
        vision.focusMode = .ContinuousAutoFocus;
        vision.videoRenderingEnabled = true;
        
        
        self.roundASquareViewOff(self.recordButton)
        self.roundASquareViewOff(self.startStopButton)
        
        self.repeater = LSRepeater.repeater(0.01, execute: {
            let vision = PBJVision.sharedInstance()
            
            var capturedSeconds = vision.capturedVideoSeconds
            
            if capturedSeconds < 0 {
                capturedSeconds = 0
            }
            
            self.timeLabel.hidden = !self.started
            
            self.timeLabel.text = String(format: "%.01f", capturedSeconds)
        })
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.animatedToOrientation(self.interfaceOrientation)
    }
    
    override func viewWillAppear(animated: Bool) {
      //  PBJVision.sharedInstance().cancelVideoCapture()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    func animatedToOrientation(interfaceOrientation: UIInterfaceOrientation) {
        
        let vision = PBJVision.sharedInstance()
        var visionOrientation:PBJCameraOrientation?
        
        switch(interfaceOrientation) {
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
    
    
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        self.animatedToOrientation(toInterfaceOrientation)
        
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
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let playbackViewController = segue.destinationViewController as! PlaybackViewController
        
        playbackViewController.url = urlToPass
    }
    
}

extension RecordViewController : PBJVisionDelegate {
    func vision(vision: PBJVision, capturedVideo videoDict: [NSObject : AnyObject]?, error: NSError?) {
        
        if videoDict != nil {
        
        if let videoPath = videoDict![PBJVisionVideoPathKey] as? String {
            
            let videoURL = NSURL(fileURLWithPath: videoPath)
            
            
                
                self.urlToPass = videoURL
                
                self.performSegueWithIdentifier("playbackSegue", sender: nil)
                self.hideBorder()
                self.recordButton.hidden = true
                
                self.started = false
        }
    }
    }
}






