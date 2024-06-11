import UIKit
import AVFoundation

class SoundTrack: UIViewController {

    var player: AVPlayer?
    var isPlaying = false
    var song: Song?
    var songs: [Song] = []
    var currentIndex: Int = 0
    var timeObserverToken: Any?
    
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var songArtistLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationTimeLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCurrentSong()
        addTimeObserver()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeTimeObserver()
    }
    
    @IBAction func previousMusicButton(_ sender: UIButton) {
        if currentIndex > 0 {
            currentIndex -= 1
            loadCurrentSong()
        }
    }
    
    @IBAction func nextMusicButton(_ sender: UIButton) {
        if currentIndex < songs.count - 1 {
            currentIndex += 1
            loadCurrentSong()
        }
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
    
    func loadCurrentSong() {
        let song = songs[currentIndex]
        self.song = song
        player = AVPlayer(url: song.url)
        songTitleLabel.text = song.title
        songArtistLabel.text = song.artist
        updateDurationLabel()
        playOrPause(playButton) // Automatically start playing the song
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

#Preview {
    SoundTrack()
}
