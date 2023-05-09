//
//  LikesViewController.swift
//  MusicApp
//
//  Created by Cengizhan Tomak on 9.05.2023.
//

import UIKit
import CoreData

class LikesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var likeTrackTableView: UITableView!
    
    private var viewModel = LikeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        cell.likeDurationLabel.text = track.value(forKey: "duration") as? String
        
        cell.likesTrackImage.layer.cornerRadius = 10
        cell.likesView.layer.cornerRadius = 10
        cell.likesView.layer.borderWidth = 1
        cell.likesView.layer.borderColor = UIColor.darkGray.cgColor
        
        return cell
    }
}
