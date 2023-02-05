//
//  ViewController.swift
//  Clock
//
//  Created by Tyler Carter on 2/3/23.
//


import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var button1: UIButton!
    @IBAction func timePicker(_ sender: Any) {
        
    }

    var counter = 0
    var timer = Timer()
    var countdown:Int = 0
    var player: AVAudioPlayer!
    var today = Date()
    var hours: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0
    let format = DateFormatter()
    var hour = Int(Calendar.current.component(.hour, from: Date()))
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUp()
    }

    @IBAction func timerButton(_ sender: UIButton) {
        if(button1.currentTitle == "Start Timer") {
            let date = timePicker.date
            let components = Calendar.current.dateComponents([.hour, .minute], from: date)
            let hr = components.hour!
            let min = components.minute!
            
            countdown = hr*3600 + min*60
            label2.isHidden = false
            button1.setTitle("Stop", for: .normal)
            
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(startTimer) , userInfo: nil, repeats: true)
            startTimer()
            
        }
        else if (button1.currentTitle == "Stop Music") {
            button1.setTitle("Start Timer", for: .normal)
            stopSound()
            label2.isHidden = true
        }
        else {
            button1.setTitle("Start Timer", for: .normal)
            timer.invalidate()
            label2.isHidden = true
        }
    }
    
    @objc func setUp() {
        button1.titleLabel?.adjustsFontSizeToFitWidth = true
        button1.titleLabel?.minimumScaleFactor = 0.4
        format.dateFormat = "EEE, dd MMM YYYY HH:mm:ss"
        label2.isHidden = true
        button1.setTitle("Start Timer", for: .normal)
        label1.text = format.string(from:Date())
        timer = Timer.scheduledTimer(timeInterval:1.0, target: self, selector:#selector(self.tick), userInfo: nil, repeats: true)
        hour = Int(Calendar.current.component(.hour, from: Date()))
        switch hour {
        case 1...12:
            background.image = UIImage(named:"day")
        case 13...24:
            background.image = UIImage(named:"night")
        default:
            background.image = UIImage(named:"day")
        }
        startSound()    }
    
    @objc func tick() {
        hour = (Calendar.current.component(.hour, from: Date()))
        label1.text = format.string(from:Date())
        switch hour {
        case 0...11:
            background.image = UIImage(named:"day")
        case 12...24:
            background.image = UIImage(named:"night")
        default:
            background.image = UIImage(named:"day")
        }
    }
  
    @objc func startTimer() {
        countdown -= 1
        label2.text = "\(String(format: "%02d", countdown/3600)):\(String(format: "%02d",(countdown%3600)/60)):\(String(format: "%02d",(countdown%60))) seconds remaining"
        if countdown == 0 {
            playSound()
            timer.invalidate()
            label2.text = "Countdown has completed"
            button1.setTitle("Stop Music", for: .normal)
        }
    }
    
    @objc func startSound() {
        guard let url = Bundle.main.url(forResource: "Sound", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url)

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    //plays sound
    @objc func playSound() {
        player?.play()
    }
    
    //stops sound
    @objc func stopSound() {
        player?.stop()
    }
}
