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

    var audioEngine: AVAudioEngine!
    var audioPlayer: AVAudioPlayerNode!
    var audioFile: AVAudioFile!
    var audioEffects: AVAudioUnitTimePitch!
    var recordedAudio: RecordedAudio!

    @IBOutlet weak var playbackRateSlider: UISlider!
    @IBOutlet weak var playbackRateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Default playback rate
        playbackRateSlider.value = 1.0
        
        // Set up the audio player
        audioFile = AVAudioFile(forReading: recordedAudio.filePathUrl, error: nil)
        audioEngine = AVAudioEngine()
        audioPlayer = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayer)
        
        // Set up playback rate and pitch effects
        audioEffects = AVAudioUnitTimePitch()
        audioEngine.attachNode(audioEffects)
        
        audioEngine.connect(audioPlayer, to: audioEffects, format: nil)
        audioEngine.connect(audioEffects, to: audioEngine.outputNode, format: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func playSoundSlowly(sender: UIButton) {
        playAudio(0.5, pitch: 1.0)
    }
    
    @IBAction func playSoundFast(sender: UIButton) {
        playAudio(1.5, pitch: 1.0)
    }
    
    @IBAction func playSoundChipmunk(sender: AnyObject) {
        playAudio(1.0, pitch: 1200.0)
    }
    
    @IBAction func playSoundDarthVader(sender: UIButton) {
        playAudio(1.0, pitch: -1200.0)
    }
    
    @IBAction func adjustPlaybackRate(sender: UISlider) {
        playAudio(playbackRateSlider.value, pitch: 1.0)
    }
    
    func playAudio(rate: Float, pitch: Float) {
        playbackRateSlider.value = rate
        playbackRateLabel.text = String(format: "Playback Rate: %.1fx", rate)
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        audioEffects.rate = rate
        audioEffects.pitch = pitch

        audioPlayer.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayer.play()
        
    }
    
    @IBAction func stopPlayback(sender: UIButton) {
        audioPlayer.stop()
//        audioPlayer.currentTime = 0
    }
}
