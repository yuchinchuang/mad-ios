//
//  ViewController.swift
//  MAD_Assignment2
//
//  Created by ychuang on 24/10/18.
//  Copyright © 2018 ychuang. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var viewVideo: UIView!
    
    var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playVideo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        playVideo()
    }
    
    func playVideo() {
        // get path for video
        let videoStr: String? = Bundle.main.path(forResource: "Scuba Diving - 699", ofType: "mp4")!
        guard let unwrappedVideoPath = videoStr else {return}
        // convert path from string to url
        let videoUrl = URL(fileURLWithPath: unwrappedVideoPath)
        // initialise video player
        self.player = AVPlayer(url: videoUrl)
        
        // play video in this view
        let layer: AVPlayerLayer = AVPlayerLayer(player: player)
        layer.frame = viewVideo.bounds
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        viewVideo.layer.addSublayer(layer)
        
        player?.play()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

