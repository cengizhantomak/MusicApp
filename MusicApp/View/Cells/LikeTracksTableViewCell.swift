//
//  LikeTracksTableViewCell.swift
//  MusicApp
//
//  Created by Cengizhan Tomak on 9.05.2023.
//

import UIKit

class LikeTracksTableViewCell: UITableViewCell {

    @IBOutlet weak var likesView: UIView!
    @IBOutlet weak var likesTrackImage: UIImageView!
    @IBOutlet weak var likeArtistLabel: UILabel!
    @IBOutlet weak var likeNameLabel: UILabel!
    @IBOutlet weak var likeDurationLabel: UILabel!
    @IBOutlet weak var likePlayIcon: UIImageView!
    @IBOutlet weak var likeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
                
        likesTrackImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        likesTrackImage.layer.cornerRadius = 10
        likesTrackImage.layer.borderWidth = 1
        likesTrackImage.layer.borderColor = UIColor.darkGray.cgColor
        
        likesTrackImage.layer.cornerRadius = 10
        likesView.layer.cornerRadius = 10
        likesView.layer.borderWidth = 1
        likesView.layer.borderColor = UIColor.darkGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
