//
//  RecordingViewController.swift
//  Pitch Perfect
//
//  Created by JD Guzman on 4/9/15.
//  Copyright (c) 2015 JD Guzman. All rights reserved.
//

import UIKit
import AVFoundation

class RecordingViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingStatusLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    
    var recorder: AVAudioRecorder!
    var audioMeta: AudioMeta!

    override func viewDidLoad() {
        super.viewDidLoad()

        initializeRecorder()
        recorder.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        stopButton.hidden = true
        recordButton.enabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func didTouchRecordingButton(sender: UIButton) {
        recordingStatusLabel.text = "Recording in progress ..."
        stopButton.hidden = false
        recordButton.enabled = false
        pauseButton.hidden = false
        pauseButton.enabled = true
        resumeButton.hidden = false
        recorder.record()
    }
    
    @IBAction func didTouchStopButton(sender: UIButton) {
        recordingStatusLabel.text = "Tap microphone to record ..."
        recorder.stop()
        AVAudioSession.sharedInstance().setActive(false, error: nil)
        pauseButton.hidden = true
        pauseButton.enabled = false
        resumeButton.hidden = true
        resumeButton.enabled = false
    }
    
    @IBAction func didTouchPauseButton(sender: UIButton) {
        recorder.pause()
        pauseButton.enabled = false
        resumeButton.enabled = true
    }
    
    @IBAction func didTouchResumeButton(sender: UIButton) {
        recorder.record()
        pauseButton.enabled = true
        resumeButton.enabled = false
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            audioMeta = AudioMeta(fileTitle: recorder.url.lastPathComponent!, filePath: recorder.url)
            performSegueWithIdentifier("transitionToPlayback", sender: audioMeta)
        } else {
            println("There was a problem with the recording")
            stopButton.hidden = true
            recordButton.enabled = true
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "transitionToPlayback") {
            let playbackVC:PlaybackViewController = segue.destinationViewController as! PlaybackViewController
            playbackVC.audioMeta = audioMeta
        }
    }
    
    private func initializeRecorder() {
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        recorder = AVAudioRecorder(URL: getAudioFilePath(), settings: nil, error: nil)
        recorder.meteringEnabled = true
        recorder.prepareToRecord()
    }
    
    private func getAudioFilePath() -> NSURL {
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let currentDateTime = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = dateFormatter.stringFromDate(currentDateTime) + ".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        return filePath!
    }
}

