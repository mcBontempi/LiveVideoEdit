//
//  PlaybackViewController.swift
//  LiveVideoEdit
//
//  Created by Daren David Taylor on 26/05/2016.
//  Copyright © 2016 HolidayExtras. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit
import AssetsLibrary

class PlaybackViewController: UIViewController {
    
    let assetLibrary = ALAssetsLibrary()
    
    var url:NSURL!
    
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    var playerLayer:AVPlayerLayer!
    var player:AVPlayer!
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.player = AVPlayer(URL: url)
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.videoView.layer.addSublayer(self.playerLayer)
        self.updatePlaybackLayer()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(playerDidFinishPlaying), name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
        
        
        
        for button in [self.playButton, self.shareButton, self.backButton] {
            self.customizeButton(button)
        
        self.bounceView(button, delay: 0.2, alpha: 1.0)
        
        }
        
        
        
        
    }
    
    func playerDidFinishPlaying(note: NSNotification) {
        self.playButton.hidden = false
        self.shareButton.hidden = false
        
        
        
        self.player.currentItem?.seekToTime(kCMTimeZero)
        
    }
    
    func save() {
        self.assetLibrary.writeVideoAtPathToSavedPhotosAlbum(self.url) { (url , error) in
            
            let vc = UIAlertController(title: "Success", message: "Video Saved", preferredStyle: .Alert)
            
            vc.addAction(UIAlertAction(title: "OK", style: .Default) { (action) in
                
                self.dismissViewControllerAnimated(true, completion: nil)
                
                
                
                })
            
            self.presentViewController(vc, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func backPressed(sender: AnyObject) {
        
            let vc = UIAlertController(title: "Loose Video", message: "If you do not save the video you will loose it.", preferredStyle: .Alert)
            
            vc.addAction(UIAlertAction(title: "Loose", style: .Default) { (action) in
                self.dismissViewControllerAnimated(true, completion:nil)
                })
            
            vc.addAction(UIAlertAction(title: "Save to Camera", style: .Default) { (action) in
                self.save()
                })
            
            self.presentViewController(vc, animated: true, completion: nil)
        }
    
    @IBAction func sharePressed(sender: AnyObject) {
        self.save()
    }
    
    @IBAction func playPressed(sender: AnyObject) {
        self.player.play()
        self.playButton.hidden = true
        self.shareButton.hidden = true
    }
    
    
    func customizeButton(button:UIButton) {
        button.layer.cornerRadius = 50
        button.layer.borderColor = UIColor.blackColor().CGColor
        button.layer.borderWidth = 3
    }
    
    func updatePlaybackLayer() {
        if let playerLayer = self.playerLayer {
            playerLayer.frame = self.view.frame
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.updatePlaybackLayer()
    }
    
    
    
    func bounceView(view: UIView, delay: NSTimeInterval, alpha:CGFloat, completion: (() -> Void)? = nil) {
        
        let alphaBefore = view.alpha
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                view.alpha = alpha
            }) { (Bool) -> Void in
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    view.alpha = alphaBefore
                })
            }
            
            view.transform = CGAffineTransformMakeScale(0.9, 0.9)
            UIView.animateWithDuration(2.0,
                                       delay: 0,
                                       usingSpringWithDamping: 0.9,
                                       initialSpringVelocity: 6.0,
                                       options: UIViewAnimationOptions.AllowUserInteraction,
                                       animations: {
                                        
                                        view.transform = CGAffineTransformIdentity
            }) {(Bool) -> Void in
                if let completion = completion {
                    completion()
                }
            }
        }
    }
}
