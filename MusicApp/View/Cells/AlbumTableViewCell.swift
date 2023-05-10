//
//  AlbumTableViewCell.swift
//  MusicApp
//
//  Created by Cengizhan Tomak on 9.05.2023.
//

import UIKit

class AlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var albumView: UIView!
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var albumReleaseDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        albumImage.layer.cornerRadius = 10
        albumView.layer.cornerRadius = 10
        albumView.layer.borderWidth = 1
        albumView.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
