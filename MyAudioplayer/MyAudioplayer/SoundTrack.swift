import UIKit
import AVFoundation

class SoundTrack: UIViewController {

    var player: AVPlayer?
    var isPlaying = false
    var trackURL: URL?
    
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var songArtistLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationTimeLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = trackURL {
            player = AVPlayer(url: url)
            songTitleLabel.text = url.lastPathComponent
        }
    }
    
    @IBAction func previousMusicButton(_ sender: UIButton) {
        // Implement previous track functionality
    }
    
    @IBAction func nextMusicButton(_ sender: UIButton) {
        // Implement next track functionality
    }
    
    @IBAction func playOrPause(_ sender: UIButton) {
        if let player = player {
            if isPlaying {
                player.pause()
                playButton.setTitle("Play", for: .normal)
            } else {
                player.play()
                playButton.setTitle("Pause", for: .normal)
            }
            isPlaying.toggle()
        }
    }
}
