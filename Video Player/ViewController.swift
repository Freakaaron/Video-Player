//
//  ViewController.swift
//  Video Player
//
//  Created by Arpit Inder Singh on 18/04/18.
//  Copyright © 2018 Arpit Inder Singh. All rights reserved.
//

import UIKit
import AVKit
import Foundation

class ViewController: UIViewController {

    var timer = Timer()
    var time: Int = 0;
    var elapsedTime: Int = 0;
 
    @IBOutlet var containerView: UIView!
    @IBOutlet var videoView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        if let path = Bundle.main.path(forResource: "Ladakh", ofType: "MOV") {
            elapsedTime = Int(CMTimeGetSeconds(AVAsset(url: Bundle.main.url(forResource: "Ladakh", withExtension: "MOV")!).duration))
            let player = AVPlayer(url: URL(fileURLWithPath: path))
            let playerLayer = AVPlayerLayer()
            playerLayer.masksToBounds = false
            playerLayer.cornerRadius = 0
            playerLayer.frame = self.view.bounds
            playerLayer.player = player
            self.view.layer.addSublayer(playerLayer)
            player.play()
            timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(ViewController.alternateDisplay), userInfo: ["player" :player, "playerLayer": playerLayer], repeats: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func alternateDisplay(timer: Timer) {
        time += 5
        //let playerLayer = AVPlayerLayer()
        let dict = timer.userInfo as? NSDictionary
        let playerLayer = dict!["playerLayer"] as! AVPlayerLayer
        let player = dict!["player"] as! AVPlayer
        if(time >= elapsedTime) {
            timer.invalidate()
        }
        if(time % 10 != 0) {
            let height = arc4random_uniform(201) + 300
            videoView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
            videoView.layer.cornerRadius = 75
            playerLayer.removeFromSuperlayer()
            containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: CGFloat(height))
            containerView.center = self.view.center
            self.view.addSubview(containerView)
            videoView.center = CGPoint(x: containerView.frame.width / 2, y: 0)
            containerView.layer.backgroundColor = UIColor.black.cgColor
            containerView.addSubview(videoView)
            playerLayer.masksToBounds = true
            playerLayer.cornerRadius = 75
            playerLayer.backgroundColor = UIColor.black.cgColor
            playerLayer.frame = videoView.bounds
            playerLayer.player = player
            videoView.layer.addSublayer(playerLayer)
        }
        else {
            videoView.removeFromSuperview()
            containerView.removeFromSuperview()
            playerLayer.masksToBounds = false
            playerLayer.cornerRadius = 0
            playerLayer.frame = self.view.bounds
            playerLayer.player = player
            self.view.layer.addSublayer(playerLayer)
        }
    }
    
}

