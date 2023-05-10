//
//  GenreCollectionViewCell.swift
//  MusicApp
//
//  Created by Cengizhan Tomak on 9.05.2023.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var genreImage: UIImageView!
    @IBOutlet weak var genreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        genreImage.layer.cornerRadius = 10
        genreImage.layer.borderWidth = 1
        genreImage.layer.borderColor = UIColor.darkGray.cgColor
    }
}
