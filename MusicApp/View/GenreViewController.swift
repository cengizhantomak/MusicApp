//
//  GenreViewController.swift
//  MusicApp
//
//  Created by Cengizhan Tomak on 9.05.2023.
//

import UIKit

class GenreViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var genreCollectionView: UICollectionView!
    
    private var genreViewModel: GenreViewModel!
    let refreshControl = UIRefreshControl()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        genreCollectionView.dataSource = self
        genreCollectionView.delegate = self
        
        genreCollectionView.showsVerticalScrollIndicator = false
        
        genreViewModel = GenreViewModel()
        genreViewModel.fetchGenres {
            DispatchQueue.main.async {
                self.genreCollectionView.reloadData()
            }
        }
        
        refreshControl.addTarget(self, action: #selector(refreshList(_:)), for: .valueChanged)
        genreCollectionView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NoNetwork.showAlertIfNoInternet(presenter: self)
    }
    
    // MARK: - Actions Selector
    @objc func refreshList(_ sender: Any) {
        if NoNetwork.isInternetAvailable() {
            genreViewModel.fetchGenres {
                DispatchQueue.main.async {
                    self.genreCollectionView.reloadData()
                }
            }
        } else {
            NoNetwork.showAlertIfNoInternet(presenter: self)
            
        }
        refreshControl.endRefreshing()
    }
    
    // MARK: - CollectionView
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
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = genreCollectionView.bounds.width
            let itemWidth = collectionViewWidth / 2 - 15
            let itemHeight = itemWidth
            return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "toArtistVC", sender: indexPath.row)
    }
    
    // MARK: - Segue Handling
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let index = sender as? Int
        let artistVC = segue.destination as! ArtistViewController
        artistVC.genre = genreViewModel.genre(at: index!)
    }
}
