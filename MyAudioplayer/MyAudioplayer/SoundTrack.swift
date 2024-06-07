//
//  SoundTrack.swift
//  MyAudioplayer
//
//  Created by хех on 07.06.2024.
//

import UIKit
import AVFoundation

class SoundTrack: UIViewController {

    var player: AVAudioPlayer?
    var isPlaying = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bundle
        player = AVPlayer (url: URL(fileURLWithPath:Bundle.main
    }
    
    @IBOutlet weak var songTitleLabel: UILabel!

    @IBOutlet weak var songArtistLabel: UILabel!
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    @IBOutlet weak var durationTimeLabel: UILabel!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBAction func previousMusicButton(_ sender: UIButton) {
    }
    
    @IBAction func nextMusicButton(_ sender: UIButton) {
    }
    
    @IBAction func playOrPause(_ sender: UIButton) {
        if(!isPlaying){
            player?.play()
            isPlaying = true
        } else {
            player?.pause()
            isPlaying = false
        }
    }
    /*
     
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
