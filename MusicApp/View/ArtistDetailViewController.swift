//
//  ArtistDetailViewController.swift
//  MusicApp
//
//  Created by Cengizhan Tomak on 9.05.2023.
//

import UIKit

class ArtistDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var albumTableView: UITableView!
    
    var artist: ArtistDataModel?
    private var artistDetailViewModel: ArtistDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        albumTableView.delegate = self
        albumTableView.dataSource = self
        
        albumTableView.separatorStyle = .none
        albumTableView.showsVerticalScrollIndicator = false
        
        navigationItem.title = artist?.name
        
        ImageLoader.shared.loadImage(from: artist!.picture_medium) { image in
            self.artistImage.image = image
        }
        
        artistDetailViewModel = ArtistDetailViewModel(artistId: artist!.id)
        artistDetailViewModel.fetchAlbums {
            DispatchQueue.main.async {
                self.albumTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artistDetailViewModel.numberOfAlbums
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = albumTableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as! AlbumTableViewCell
        
        let album = artistDetailViewModel.album(at: indexPath.row)
        ImageLoader.shared.loadImage(from: album.cover_medium) { image in
            cell.albumImage.image = image
        }
        
        cell.albumNameLabel.text = album.title
        cell.albumReleaseDateLabel.text = album.release_date
        
        cell.albumImage.layer.cornerRadius = 10
        cell.albumView.layer.cornerRadius = 10
        cell.albumView.layer.borderWidth = 1
        cell.albumView.layer.borderColor = UIColor.darkGray.cgColor
        
        return cell
    }
}
