//
//  SoundViewController.swift
//  SoundBoard
//
//  Created by Toby Zitsman on 6/27/17.
//  Copyright © 2017 Toby Zitsman. All rights reserved.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController {
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nameText: UITextField!
    
    var audioRecorder : AVAudioRecorder?
    var audioPlayer : AVAudioPlayer?
    var audioURL : URL?
    
    
    
    @IBAction func recordTapped(_ sender: Any) {
        if audioRecorder!.isRecording {
            audioRecorder?.stop()
            
            recordButton.setTitle("Record", for: .normal)
        } else {
            audioRecorder?.record()
            
            recordButton.setTitle("STOP", for: .normal)
            
            playButton.isEnabled = true
            addButton.isHidden = false
        }
    }
    
    @IBAction func playTapped(_ sender: Any) {
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer!.play()
        } catch {}
    }
    
    @IBAction func addTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let sound = Sound(context: context)
        
        sound.name = nameText.text
        sound.audio = NSData(contentsOf: audioURL!)
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        navigationController!.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpRecorder()
        playButton.isEnabled = false
        addButton.isHidden = true
    }
    
    func setUpRecorder() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            
            let pathComponents = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
            var settings : [String: Any] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC)
            settings[AVSampleRateKey] = 44100.0
            settings[AVNumberOfChannelsKey] = 2
            
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            
            audioRecorder!.prepareToRecord()
        } catch let error as NSError {
            print(error)
        }
    }
    
}
