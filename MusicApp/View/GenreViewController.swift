//
//  GenreViewController.swift
//  MusicApp
//
//  Created by Cengizhan Tomak on 9.05.2023.
//

import UIKit

class GenreViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var genreCollectionView: UICollectionView!
    
    private var genreViewModel: GenreViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        genreCollectionView.dataSource = self
        genreCollectionView.delegate = self
        
        genreViewModel = GenreViewModel()
        genreViewModel.fetchGenres {
            DispatchQueue.main.async {
                self.genreCollectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genreViewModel.numberOfGenres
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = genreCollectionView.dequeueReusableCell(withReuseIdentifier: "genreCell", for: indexPath) as! GenreCollectionViewCell
        
        let genre = genreViewModel.genre(at: indexPath.row)
        cell.genreLabel.text = genre.name
        
        ImageLoader.shared.loadImage(from: genre.picture_medium) { image in
            cell.genreImage.image = image
        }
        
        cell.genreImage.layer.cornerRadius = 10
        
        return cell
    }
}
