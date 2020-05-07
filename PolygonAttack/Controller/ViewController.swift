//
//  ViewController.swift
//  PolygonAttack
//
//  Created by Field Employee on 4/1/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var gameBackgroundMusic = AVAudioPlayer()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    do
    {
        let musicPath = Bundle.main.path(forResource: "Music&Sound/bensound-adaytoremember", ofType: "mp3")
        try gameBackgroundMusic = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: musicPath!) as URL)
    }
    catch
    {
        
    }
    
  }
    override func viewWillAppear(_ animated: Bool) {
        gameBackgroundMusic.numberOfLoops = -1
        gameBackgroundMusic.play()
    }
    
    @IBAction func MuteButton(_ sender: Any) {
        if gameBackgroundMusic.volume != 0.0{
            gameBackgroundMusic.volume = 0.0
        }
        else{
            gameBackgroundMusic.volume = 1.0
        }

    }
    
}

