//
//  PlaybackViewController.swift
//  Pitch Perfect
//
//  Created by JD Guzman on 4/10/15.
//  Copyright (c) 2015 JD Guzman. All rights reserved.
//

import UIKit
import AVFoundation

class PlaybackViewController: UIViewController {
    
    @IBOutlet weak var volumeSlider: UISlider!
    
    var player: AVAudioPlayer!
    
    var audioMeta: AudioMeta!
    
    var audioEngine: AVAudioEngine!
    
    var audioFile: AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAudioFile()
        setupVolumeSlider()
        
        audioEngine = AVAudioEngine()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didPressSnailPlaybackButton(sender: UIButton) {
        playAudioWithRate(0.5)
    }
    
    @IBAction func didPressRabbitPlaybackButton(sender: UIButton) {
        playAudioWithRate(2.0)
    }
    
    @IBAction func didPressChipmunkPlaybackButton(sender: UIButton) {
        playAudioWithPitch(1000)
    }
    
    @IBAction func didPressVaderPlaybackButton(sender: UIButton) {
        playAudioWithPitch(-1000)
    }
    
    @IBAction func didPressEchoPlaybackButton(sender: UIButton) {
        resetAudio()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var delayEffect = AVAudioUnitDelay()
        delayEffect.wetDryMix = 40
        audioEngine.attachNode(delayEffect)
        
        audioEngine.connect(audioPlayerNode, to: delayEffect, format: nil)
        audioEngine.connect(delayEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    @IBAction func didPressReverbPlaybackButton(sender: UIButton) {
        resetAudio()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var reverbEffect = AVAudioUnitReverb()
        reverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
        reverbEffect.wetDryMix = 70
        audioEngine.attachNode(reverbEffect)
        
        audioEngine.connect(audioPlayerNode, to: reverbEffect, format: nil)
        audioEngine.connect(reverbEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    @IBAction func didPressStopButton(sender: UIButton) {
        resetAudio()
    }
    
    @IBAction func didChangeVolumeSlider(sender: UISlider, forEvent event: UIEvent) {
        player.volume = sender.value
    }
    
    private func loadAudioFile() {
        if var audioUrl = audioMeta.path {
            player = AVAudioPlayer(contentsOfURL: audioUrl, error: nil)
            player.enableRate = true
            
            audioFile = AVAudioFile(forReading: audioUrl, error: nil)
        } else {
            println("Error loading audio file.")
        }
    }
    
    private func setupVolumeSlider() {
        volumeSlider.setValue(0.5, animated: true)
        player.volume = volumeSlider.value
    }
    
    private func playAudioWithRate(rate: Float) {
        resetAudio()
        player.rate = rate
        player.play()
    }
    
    private func resetAudio() {
        if player.playing {
            player.stop()
        }
        
        player.currentTime = 0
        
        audioEngine.stop()
        audioEngine.reset()
    }
    
    private func playAudioWithPitch(pitch: Float) {
        resetAudio()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }

}
