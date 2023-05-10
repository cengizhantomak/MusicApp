//
//  ArtistCollectionViewCell.swift
//  MusicApp
//
//  Created by Cengizhan Tomak on 9.05.2023.
//

import UIKit

class ArtistCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        artistImage.layer.cornerRadius = 10
        artistImage.layer.borderWidth = 1
        artistImage.layer.borderColor = UIColor.darkGray.cgColor
    }
}
