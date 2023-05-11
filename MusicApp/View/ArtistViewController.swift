//
//  ArtistViewController.swift
//  MusicApp
//
//  Created by Cengizhan Tomak on 9.05.2023.
//

import UIKit

class ArtistViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var artistCollectionView: UICollectionView!
    
    var genre: GenreDataModel?
    private var artistViewModel: ArtistViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        artistCollectionView.delegate = self
        artistCollectionView.dataSource = self
        
        artistCollectionView.showsVerticalScrollIndicator = false
        
        artistViewModel = ArtistViewModel(genreId: genre!.id)
        artistViewModel.fetchArtists {
            DispatchQueue.main.async {
                self.artistCollectionView.reloadData()
            }
        }
        
        navigationItem.title = genre?.name
    }
    
    // MARK: - CollectionView
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
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = artistCollectionView.bounds.width
            let itemWidth = collectionViewWidth / 2 - 15
            let itemHeight = itemWidth
        
            return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toArtistDetailVC", sender: indexPath.row)
    }
    
    // MARK: - Segue Handling
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let index = sender as? Int
        let artistDetailVC = segue.destination as! ArtistDetailViewController
        artistDetailVC.artist = artistViewModel.artist(at: index!)
    }
}
