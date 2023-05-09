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
    @IBOutlet weak var likeNameLabel: UILabel!
    @IBOutlet weak var likeDurationLabel: UILabel!
    @IBOutlet weak var likePlayIcon: UIImageView!
    @IBOutlet weak var likeImage: UIImageView!
    
//    var isFavorited: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
