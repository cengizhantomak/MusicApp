//
//  AlbumDetailViewController.swift
//  MusicApp
//
//  Created by Cengizhan Tomak on 9.05.2023.
//

import UIKit
import AVFoundation

class AlbumDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var trackTableView: UITableView!
    
    var album: ArtistDetailDataModel?
    var albumDetailViewModel: AlbumDetailViewModel!
    
    var audioPlayer: AVPlayer?
    var isPlaying: Bool = false
    var currentPlayingIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trackTableView.delegate = self
        trackTableView.dataSource = self
        
        trackTableView.separatorStyle = .none
        trackTableView.showsVerticalScrollIndicator = false
        
        navigationItem.title = album?.title
        
        albumDetailViewModel = AlbumDetailViewModel(albumId: album!.id)
        albumDetailViewModel.fetchTracks {
            DispatchQueue.main.async {
                self.trackTableView.reloadData()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        audioPlayer?.pause()
        audioPlayer = nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumDetailViewModel.numberOfTracks
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = trackTableView.dequeueReusableCell(withIdentifier: "trackCell", for: indexPath) as! TrackTableViewCell
        
        let track = albumDetailViewModel.track(at: indexPath.row)
        ImageLoader.shared.loadImage(from: album!.cover_medium) { image in
            cell.trackImage.image = image
        }
        
        cell.trackNameLabel.text = track.title
        
        let trackDurationInSeconds = track.duration
        cell.trackDuration.text = albumDetailViewModel.secondsToMinutesSeconds(seconds: trackDurationInSeconds)
        
        cell.playIcon.isHidden = true
        
        cell.trackImage.layer.cornerRadius = 10
        cell.trackView.layer.cornerRadius = 10
        cell.trackView.layer.borderWidth = 1
        cell.trackView.layer.borderColor = UIColor.darkGray.cgColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        trackTableView.deselectRow(at: indexPath, animated: true)
        
        let selectedTrack = albumDetailViewModel.track(at: indexPath.row)
        let selectedCell = trackTableView.cellForRow(at: indexPath) as! TrackTableViewCell
        
        if currentPlayingIndexPath == indexPath && isPlaying {
            audioPlayer?.pause()
            isPlaying = false
            selectedCell.playIcon.isHidden = true
            
        } else {
            
            if let previousPlayingIndexPath = currentPlayingIndexPath, let previousCell = trackTableView.cellForRow(at: previousPlayingIndexPath) as? TrackTableViewCell {
                previousCell.playIcon.isHidden = true
            }
            
            if let previewURL = URL(string: selectedTrack.preview) {
                let playerItem = AVPlayerItem(url: previewURL)
                
                currentPlayingIndexPath = indexPath
                
                audioPlayer = AVPlayer(playerItem: playerItem)
                audioPlayer?.play()
                isPlaying = true
                selectedCell.playIcon.isHidden = false
            }
        }
    }
}
