//
//  AlbumDetailViewController.swift
//  MusicApp
//
//  Created by Cengizhan Tomak on 9.05.2023.
//

import UIKit

class AlbumDetailViewController: UIViewController {
    
    @IBOutlet weak var trackTableView: UITableView!
    
    var album: ArtistDetailDataModel?
    var albumDetailViewModel: AlbumDetailViewModel!
    let refreshControl = UIRefreshControl()
    
    // MARK: - Lifecycle
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
        
        refreshControl.addTarget(self, action: #selector(refreshList(_:)), for: .valueChanged)
        trackTableView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NoNetwork.showAlertIfNoInternet(presenter: self)
        trackTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        albumDetailViewModel.stopPlaying()
    }
    
    // MARK: - Actions Selector
    @objc func refreshList(_ sender: Any) {
        if NoNetwork.isInternetAvailable() {
            albumDetailViewModel = AlbumDetailViewModel(albumId: album!.id)
            albumDetailViewModel.fetchTracks {
                DispatchQueue.main.async {
                    self.trackTableView.reloadData()
                }
            }
        } else {
            NoNetwork.showAlertIfNoInternet(presenter: self)
        }
        refreshControl.endRefreshing()
    }
    
    @objc func likeImageTapped(_ sender: UITapGestureRecognizer) {
        guard let row = sender.view?.tag else{ return }
        
        guard let cell = trackTableView.cellForRow(at: IndexPath(row: row, section: 0)) as? TrackTableViewCell else {
            return
        }
        
        cell.isFavorited.toggle()
        
        let track = albumDetailViewModel.track(at: row)
        
        if albumDetailViewModel.isFavoriteTrack(track) {
            albumDetailViewModel.removeTrackFromCoreData(track: track)
            cell.likeImage.image = UIImage(systemName: "heart")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        } else {
            albumDetailViewModel.saveTrackToCoreData(track: track, albumImageUrl: album!.cover_medium)
            cell.likeImage.image = UIImage(systemName: "heart.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        }
    }
}

// MARK: - TableView
extension AlbumDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        
        cell.isFavorited = false
        cell.likeImage.image = UIImage(systemName: "heart")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        cell.likeImage.isUserInteractionEnabled = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(likeImageTapped(_:)))
        cell.likeImage.addGestureRecognizer(tapGestureRecognizer)
        cell.likeImage.tag = indexPath.row
        
        if albumDetailViewModel.isFavoriteTrack(track) {
            cell.likeImage.image = UIImage(systemName: "heart.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        } else {
            cell.likeImage.image = UIImage(systemName: "heart")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        }
        
        cell.playIcon.isHidden = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        trackTableView.deselectRow(at: indexPath, animated: true)
        
        albumDetailViewModel.playPauseTrack(at: indexPath.row)
            
            trackTableView.visibleCells.forEach { cell in
                guard let trackCell = cell as? TrackTableViewCell else { return }
                trackCell.playIcon.isHidden = true
            }
            
            let selectedCell = trackTableView.cellForRow(at: indexPath) as! TrackTableViewCell
            selectedCell.playIcon.isHidden = !albumDetailViewModel.isPlaying
    }
}
