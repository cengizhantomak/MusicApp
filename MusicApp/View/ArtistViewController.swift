//
//  ArtistViewController.swift
//  MusicApp
//
//  Created by Cengizhan Tomak on 9.05.2023.
//

import UIKit

class ArtistViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var genre: GenreDataModel?
    private var artistViewModel: ArtistViewModel!
    
    @IBOutlet weak var artistCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        artistCollectionView.delegate = self
        artistCollectionView.dataSource = self
        
        artistViewModel = ArtistViewModel(genreId: genre!.id)
        artistViewModel.fetchArtists {
            DispatchQueue.main.async {
                self.artistCollectionView.reloadData()
            }
        }
        
        navigationItem.title = genre?.name
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artistViewModel.numberOfArtists
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = artistCollectionView.dequeueReusableCell(withReuseIdentifier: "artistCell", for: indexPath) as! ArtistCollectionViewCell
        
        let artist = artistViewModel.artist(at: indexPath.row)
        cell.artistLabel.text = artist.name
        
        ImageLoader.shared.loadImage(from: artist.picture_medium) { image in
            cell.artistImage.image = image
        }
        
        cell.artistImage.layer.cornerRadius = 10
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toArtistDetailVC", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let index = sender as? Int
        let artistDetailVC = segue.destination as! ArtistDetailViewController
        artistDetailVC.artist = artistViewModel.artist(at: index!)
    }
}
