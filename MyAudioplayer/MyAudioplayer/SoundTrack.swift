import UIKit
import AVFoundation

class SoundTrack: UIViewController {

    var player: AVPlayer?
    var isPlaying = false
    var song: Song?
    var timeObserverToken: Any?
    
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var songArtistLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationTimeLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet var prevTrackButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    
    @IBOutlet var nextTrackButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let song = song {
            player = AVPlayer(url: song.url)
            songTitleLabel.text = song.title
            songArtistLabel.text = song.artist
            addTimeObserver()
            updateDurationLabel()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeTimeObserver()
    }
    
    @IBAction func previousMusic(_ sender: UIButton) {
        // Implement previous track functionality if needed
    }
    
    @IBAction func nextMusic(_ sender: UIButton) {
        // Implement next track functionality if needed
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
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        if let player = player, let duration = player.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(sender.value) * totalSeconds
            let seekTime = CMTime(value: CMTimeValue(value * 1000), timescale: 1000)
            player.seek(to: seekTime)
        }
    }
    
    func addTimeObserver() {
        if let player = player {
            let interval = CMTime(seconds: 1, preferredTimescale: 2)
            timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
                let seconds = CMTimeGetSeconds(time)
                self?.currentTimeLabel.text = self?.formatTime(seconds: seconds)
                self?.updateSlider()
            }
        }
    }
    
    func removeTimeObserver() {
        if let player = player, let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
    func updateDurationLabel() {
        if let duration = player?.currentItem?.duration {
            let seconds = CMTimeGetSeconds(duration)
            durationTimeLabel.text = formatTime(seconds: seconds)
        }
    }
    
    func updateSlider() {
        if let player = player, let duration = player.currentItem?.duration {
            let currentTime = CMTimeGetSeconds(player.currentTime())
            let totalTime = CMTimeGetSeconds(duration)
            timeSlider.value = Float(currentTime / totalTime)
        }
    }
    
    func formatTime(seconds: Float64) -> String {
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}

#Preview{
    SoundTrack()
}
