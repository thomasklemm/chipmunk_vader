//
//  PlayerViewController.swift
//  Pitch Perfect
//
//  Created by Thomas on 06.03.15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {

    var audioPlayer: AVAudioPlayer!
    var recordedAudio: RecordedAudio!

    @IBOutlet weak var playbackRateSlider: UISlider!
    @IBOutlet weak var playbackRateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the audio player
        audioPlayer = AVAudioPlayer(contentsOfURL: recordedAudio.filePathUrl, error: nil)
        
        // Enables modifying the playback rate while playing the audio
        audioPlayer.enableRate = true
        
        // Default playback rate
        playbackRateSlider.value = 1.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func playSoundSlowly(sender: UIButton) {
        playAudio(0.5)
    }
    
    @IBAction func playSoundFast(sender: UIButton) {
        playAudio(1.5)
    }
    
    @IBAction func adjustPlaybackRate(sender: UISlider) {
        playAudio(playbackRateSlider.value)
    }
    
    func playAudio(rate: Float) {
        playbackRateSlider.value = rate
        playbackRateLabel.text = String(format: "Playback Rate: %.1fx", rate)
        
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    @IBAction func stopPlayback(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
    }
}
