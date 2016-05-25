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
    
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var recordButton: UIView!
  
    var started:Bool = false
    var recording:Bool = false
    
    let assetLibrary = ALAssetsLibrary()
    
    @IBAction func longPressPressed(gestureRecognizer: UILongPressGestureRecognizer) {
        
        switch (gestureRecognizer.state) {
        case .Began:
            if self.recording == false {
                
                self.recording = true
                
                PBJVision.sharedInstance().startVideoCapture()
                
                print ("start")
                
            }
            else {
                
                PBJVision.sharedInstance().resumeVideoCapture()
           
                print ("resume")
                
            }
        case .Ended, .Cancelled, .Failed:
            PBJVision.sharedInstance().pauseVideoCapture()
            
            print ("pause")
            
        default:
            break;
        }
    }
    
    
    
    
    
    
    @IBAction func startStopPressed(sender: AnyObject) {
        
        if self.started == false {
            self.started = true
            
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
      //  vision.additionalCompressionProperties = @{AVVideoProfileLevelKey : AVVideoProfileLevelH264Baseline30};
        
        
        
        
        
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
    
    
    /*
    
    func vision(PBJVision *)vision capturedVideo:(NSDictionary *)videoDict error:(NSError *)error
    {
    _recording = NO;
    
    if (error && [error.domain isEqual:PBJVisionErrorDomain] && error.code == PBJVisionErrorCancelled) {
    NSLog(@"recording session cancelled");
    return;
    } else if (error) {
    NSLog(@"encounted an error in video capture (%@)", error);
    return;
    }
    
    _currentVideo = videoDict;
    
    NSString *videoPath = [_currentVideo  objectForKey:PBJVisionVideoPathKey];
    [_assetLibrary writeVideoAtPathToSavedPhotosAlbum:[NSURL URLWithString:videoPath] completionBlock:^(NSURL *assetURL, NSError *error1) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Video Saved!" message: @"Saved to the camera roll."
    delegate:self
    cancelButtonTitle:nil
    otherButtonTitles:@"OK", nil];
    [alert show];
    }];
    }


    */
    
    
}

extension RecordViewController : PBJVisionDelegate {
    func vision(vision: PBJVision, capturedVideo videoDict: [NSObject : AnyObject]?, error: NSError?) {
  
        
        let videoPath = videoDict![PBJVisionVideoPathKey] as! String
        
        let videoURL = NSURL(string: videoPath)
        
        self.assetLibrary.writeVideoAtPathToSavedPhotosAlbum(videoURL) { (url , error) in
            
            self.performSegueWithIdentifier("previewSegue", sender: nil)
            
        }
        
        
    }
}






