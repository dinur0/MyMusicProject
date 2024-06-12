import UIKit
import AVFoundation

struct Song {
    let url: URL
    let title: String
    let artist: String
}

class TableViewController: UITableViewController {

//    @IBOutlet var musicTitle: UILabel!
//    @IBOutlet var musicAuthor: UILabel!
    var songs: [Song] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMusicFiles()
    }
    
    func loadMusicFiles() {
        // Получение пути к каталогу проекта
        let projectDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.deletingLastPathComponent()
        let musicFolderPath = projectDirectory?.appendingPathComponent("MSC")

        guard let musicPath = musicFolderPath else {
            print("Could not find project directory.")
            return
        }
        
        let fileManager = FileManager.default
        do {
            let files = try fileManager.contentsOfDirectory(atPath: musicPath.path)
            for file in files {
                if file.hasSuffix(".mp3") {
                    let fileURL = musicPath.appendingPathComponent(file)
                    let metadata = getMetadata(for: fileURL)
                    let song = Song(url: fileURL, title: metadata.title, artist: metadata.artist)
                    songs.append(song)
                    print("Loaded song: \(song.title) by \(song.artist)")
//                    musicTitle.text = song.title
//                    musicAuthor.text = song.artist
                    
                }
            }
        } catch {
            print("Error while enumerating files at \(musicPath.path): \(error.localizedDescription)")
        }
        
        tableView.reloadData()
    }

    func getMetadata(for url: URL) -> (title: String, artist: String) {
        let asset = AVAsset(url: url)
        var title = "Unknown Title"
        var artist = "Unknown Artist"
        
        for metadataItem in asset.commonMetadata {
            if metadataItem.commonKey == .commonKeyTitle {
                title = metadataItem.stringValue ?? title
            } else if metadataItem.commonKey == .commonKeyArtist {
                artist = metadataItem.stringValue ?? artist
            }
        }
        
        return (title, artist)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return songs.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let song = songs[indexPath.row]
        cell.textLabel?.text = song.title
        cell.detailTextLabel?.text = song.artist
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSoundTrack", let destination = segue.destination as? SoundTrack {
            if let indexPath = tableView.indexPathForSelectedRow {
                destination.song = songs[indexPath.row]
                destination.songs = songs
                destination.currentIndex = indexPath.row
            }
        }
    }
}
