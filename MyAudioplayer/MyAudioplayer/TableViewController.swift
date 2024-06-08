import UIKit

class TableViewController: UITableViewController {

    var songs: [URL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMusicFiles()
    }
    
    func loadMusicFiles() {
        if let resourcePath = Bundle.main.resourcePath {
            let musicFolderPath = resourcePath + "/Musics"
            let fileManager = FileManager.default
            do {
                let files = try fileManager.contentsOfDirectory(atPath: musicFolderPath)
                for file in files {
                    if file.hasSuffix(".mp3") {
                        let filePath = musicFolderPath + "/" + file
                        let fileURL = URL(fileURLWithPath: filePath)
                        songs.append(fileURL)
                    }
                }
            } catch {
                print("Error while enumerating files \(musicFolderPath): \(error.localizedDescription)")
            }
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = songs[indexPath.row].lastPathComponent
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSoundTrack", let destination = segue.destination as? SoundTrack {
            if let indexPath = tableView.indexPathForSelectedRow {
                destination.trackURL = songs[indexPath.row]
            }
        }
    }
}
