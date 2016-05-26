//
//  RecordViewController.swift
//  LiveVideoEdit
//
//  Created by Daren David Taylor on 24/05/2016.
//  Copyright © 2016 HolidayExtras. All rights reserved.
//

import UIKit
import PBJVision
import AssetsLibrary


class RecordViewController: UIViewController {
    
    
    var urlToPass:NSURL!
    
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var recordButton: UIView!
    
    var started:Bool = false
    var recording:Bool = false
    
    let assetLibrary = ALAssetsLibrary()
    
    override func shouldAutorotate() -> Bool {
        return !self.started
    }
    
    func colorBorder(color: UIColor) {
        self.previewView.layer.borderColor = color.CGColor
        self.previewView.layer.borderWidth = 10
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
                self.colorBorder(UIColor.redColor())
                print ("start")
            }
            else {
                PBJVision.sharedInstance().resumeVideoCapture()
                self.colorBorder(UIColor.redColor())
                print ("resume")
            }
        case .Ended, .Cancelled, .Failed:
            PBJVision.sharedInstance().pauseVideoCapture()
            self.colorBorder(UIColor.yellowColor())
            print ("pause")
        default:
            break;
        }
    }
    
    @IBAction func startStopPressed(sender: AnyObject) {
        if self.started == false {
            self.started = true
            self.colorBorder(UIColor.yellowColor())
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PBJVision.sharedInstance().delegate = self
        self.createPreviewView()
        PBJVision.sharedInstance().startPreview()
        
        let vision = PBJVision.sharedInstance()
        
        vision.cameraMode = .Video;
        vision.focusMode = .AutoFocus;
        vision.outputFormat = .Standard;
        vision.videoRenderingEnabled = true;
        vision.additionalCompressionProperties = [AVVideoProfileLevelKey : AVVideoProfileLevelH264HighAutoLevel]
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
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
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let playbackViewController = segue.destinationViewController as! PlaybackViewController
        
        playbackViewController.url = urlToPass
    }
    
}

extension RecordViewController : PBJVisionDelegate {
    func vision(vision: PBJVision, capturedVideo videoDict: [NSObject : AnyObject]?, error: NSError?) {
        
        
        if let videoPath = videoDict![PBJVisionVideoPathKey] as? String {
            
            let videoURL = NSURL(fileURLWithPath: videoPath)
            
        //    self.assetLibrary.writeVideoAtPathToSavedPhotosAlbum(videoURL) { (url , error) in
                
                
                self.urlToPass = videoURL
                
                self.performSegueWithIdentifier("playbackSegue", sender: nil)
                self.hideBorder()
                self.recordButton.hidden = true
                
                self.started = false
              /*
                let vc = UIAlertController(title: "Video Operation", message: "Video Saved", preferredStyle: .Alert)
                
                vc.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                
                self.presentViewController(vc
                    , animated: true, completion: {
                        
                        
                })
 
 */
        //    }
        }
    }
}






