//
//  RecorderViewController.swift
//  Pitch Perfect
//
//  Created by Thomas on 06.03.15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

import UIKit
import AVFoundation

class RecorderViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var audioSession = AVAudioSession.sharedInstance()
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        // Hide the stop button and recording in progress label
        stopButton.hidden = true
        recordingInProgress.hidden = true
        
        // Enable the record button
        recordButton.enabled = true
    }

    func startRecording() {
        // Show the stop button and recording in progress label
        stopButton.hidden = false
        recordingInProgress.hidden = false
        
        // Disable the record button
        recordButton.enabled = false
    }
    
    func stopRecording() {
        recordingInProgress.hidden = true
        stopButton.hidden = true
        
        recordButton.enabled = true
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        startRecording()
        
        // Record user's audio
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        audioSession.setCategory(AVAudioSessionCategoryRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.record()
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        // Stop recording the user's audio
        audioRecorder.stop()
        audioSession.setActive(false, error: nil)
        
        stopRecording()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            // Save the recorded audio
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            
            // Perform seque to play sounds
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("Recording was unsuccessful. Please try again.")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playerViewController: PlayerViewController = segue.destinationViewController as PlayerViewController
            let audio = sender as RecordedAudio
            playerViewController.recordedAudio = audio
        }
    }

}