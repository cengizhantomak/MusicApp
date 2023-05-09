//
//  AlbumDetailViewController.swift
//  MusicApp
//
//  Created by Cengizhan Tomak on 9.05.2023.
//

import UIKit

class AlbumDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var trackTableView: UITableView!
    
    var album: ArtistDetailDataModel?
    var albumDetailViewModel: AlbumDetailViewModel!
    
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
        cell.trackDuration.text = String(track.duration)
        
        cell.trackImage.layer.cornerRadius = 10
        cell.trackView.layer.cornerRadius = 10
        cell.trackView.layer.borderWidth = 1
        cell.trackView.layer.borderColor = UIColor.darkGray.cgColor
        
        return cell
    }
}
