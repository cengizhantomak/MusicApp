//
//  LikesViewController.swift
//  MusicApp
//
//  Created by Cengizhan Tomak on 9.05.2023.
//

import UIKit

class LikesViewController: UIViewController {
    
    @IBOutlet weak var likeTrackTableView: UITableView!
    @IBOutlet weak var searchTrack: UISearchBar!
    
    private var viewModel = LikeViewModel()
    let refreshControl = UIRefreshControl()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTrack.delegate = self
        
        likeTrackTableView.delegate = self
        likeTrackTableView.dataSource = self
        
        likeTrackTableView.separatorStyle = .none
        likeTrackTableView.showsVerticalScrollIndicator = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        refreshControl.addTarget(self, action: #selector(refreshList(_:)), for: .valueChanged)
        likeTrackTableView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NoNetwork.showAlertIfNoInternet(presenter: self)
        viewModel.fetchFavoriteTracks()
        likeTrackTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewModel.stopPlaying()
    }
    
    // MARK: - Actions Selector
    @objc func refreshList(_ sender: Any) {
        if NoNetwork.isInternetAvailable() {
            
        } else {
            NoNetwork.showAlertIfNoInternet(presenter: self)
        }
        refreshControl.endRefreshing()
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
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

// MARK: - TableView
extension LikesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = likeTrackTableView.dequeueReusableCell(withIdentifier: "likeTrackCell", for: indexPath) as! LikeTracksTableViewCell
        
        let track = viewModel.track(at: indexPath.row)
        
        ImageLoader.shared.loadImage(from: track.value(forKey: "imageUrl") as! String) { image in
            cell.likesTrackImage.image = image
        }
        
        cell.likeArtistLabel.text = track.value(forKey: "artist") as? String
        
        cell.likeNameLabel.text = track.value(forKey: "title") as? String
        
        let trackDurationInSeconds = track.value(forKey: "duration") as? Int ?? 0
        let duration = viewModel.secondsToMinutesSeconds(seconds: trackDurationInSeconds)
        cell.likeDurationLabel.text = duration
        
        cell.likeImage.image = UIImage(systemName: "heart.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(likeImageTapped(_:)))
        cell.likeImage.addGestureRecognizer(tapGestureRecognizer)
        cell.likeImage.isUserInteractionEnabled = true
        cell.likeImage.tag = indexPath.row
        
        cell.likePlayIcon.isHidden = true

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        likeTrackTableView.deselectRow(at: indexPath, animated: true)
        
        viewModel.playPauseTrack(at: indexPath.row)
        
        likeTrackTableView.visibleCells.forEach { cell in
            guard let likeCell = cell as? LikeTracksTableViewCell else { return }
            likeCell.likePlayIcon.isHidden = true
        }
        
        let selectedCell = likeTrackTableView.cellForRow(at: indexPath) as! LikeTracksTableViewCell
        selectedCell.likePlayIcon.isHidden = !viewModel.isPlaying
    }
}

// MARK: - SearchBar
extension LikesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterTracks(with: searchText)
        likeTrackTableView.reloadData()
    }
}
