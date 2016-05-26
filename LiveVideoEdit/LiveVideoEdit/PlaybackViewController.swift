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

class PlaybackViewController: UIViewController {
    
    var url:NSURL!
    
    
    var playerLayer:AVPlayerLayer!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let player = AVPlayer(URL: url)
        self.playerLayer = AVPlayerLayer(player: player)
   
        self.view.layer.addSublayer(self.playerLayer)
   
        self.updatePlaybackLayer()
        
        player.play()
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
    
    
}
