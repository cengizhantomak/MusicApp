//
//  LikesViewController.swift
//  MusicApp
//
//  Created by Cengizhan Tomak on 9.05.2023.
//

import UIKit
import CoreData
import AVFoundation

class LikesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var likeTrackTableView: UITableView!
    @IBOutlet weak var searchTrack: UISearchBar!
    
    private var viewModel = LikeViewModel()
    
    var audioPlayer: AVPlayer?
    var isPlaying: Bool = false
    var currentPlayingIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTrack.delegate = self
        
        likeTrackTableView.delegate = self
        likeTrackTableView.dataSource = self
        
        likeTrackTableView.separatorStyle = .none
        likeTrackTableView.showsVerticalScrollIndicator = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchFavoriteTracks()
        likeTrackTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        audioPlayer?.pause()
        audioPlayer = nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = likeTrackTableView.dequeueReusableCell(withIdentifier: "likeTrackCell", for: indexPath) as! LikeTracksTableViewCell
        
        let track = viewModel.track(at: indexPath.row)
        
        ImageLoader.shared.loadImage(from: track.value(forKey: "imageUrl") as! String) { image in
            cell.likesTrackImage.image = image
        }
        
        cell.likeNameLabel.text = track.value(forKey: "title") as? String
        
        let trackDurationInSeconds = track.value(forKey: "duration") as? Int ?? 0
        let duration = viewModel.secondsToMinutesSeconds(seconds: trackDurationInSeconds)
        cell.likeDurationLabel.text = duration
        
        cell.likePlayIcon.isHidden = true
        
        cell.likeImage.image = UIImage(systemName: "heart.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(likeImageTapped(_:)))
        cell.likeImage.addGestureRecognizer(tapGestureRecognizer)
        cell.likeImage.isUserInteractionEnabled = true
        cell.likeImage.tag = indexPath.row
        
        cell.likesTrackImage.layer.cornerRadius = 10
        cell.likesView.layer.cornerRadius = 10
        cell.likesView.layer.borderWidth = 1
        cell.likesView.layer.borderColor = UIColor.darkGray.cgColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        likeTrackTableView.deselectRow(at: indexPath, animated: true)
        
        let selectedTrack = viewModel.track(at: indexPath.row)
        let selectedCell = likeTrackTableView.cellForRow(at: indexPath) as! LikeTracksTableViewCell
        
        if currentPlayingIndexPath == indexPath && isPlaying {
            audioPlayer?.pause()
            isPlaying = false
            selectedCell.likePlayIcon.isHidden = true
            
        } else {
            
            if let previousPlayingIndexPath = currentPlayingIndexPath, let previousCell = likeTrackTableView.cellForRow(at: previousPlayingIndexPath) as? LikeTracksTableViewCell {
                previousCell.likePlayIcon.isHidden = true
            }
            
            if let previewURL = URL(string: selectedTrack.value(forKey: "preview") as! String) {
                let playerItem = AVPlayerItem(url: previewURL)
                
                currentPlayingIndexPath = indexPath
                
                audioPlayer = AVPlayer(playerItem: playerItem)
                audioPlayer?.play()
                isPlaying = true
                selectedCell.likePlayIcon.isHidden = false
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterTracks(with: searchText)
        likeTrackTableView.reloadData()
    }
    
    @objc func likeImageTapped(_ sender: UITapGestureRecognizer) {
        guard let row = sender.view?.tag else { return }
        let track = viewModel.track(at: row)
        
        viewModel.deleteTrackFromCoreData(track: track)
        viewModel.removeTrack(at: row)
        likeTrackTableView.deleteRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
        likeTrackTableView.reloadData()
    }
}
