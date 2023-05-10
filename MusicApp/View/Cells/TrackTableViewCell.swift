//
//  TrackTableViewCell.swift
//  MusicApp
//
//  Created by Cengizhan Tomak on 9.05.2023.
//

import UIKit

class TrackTableViewCell: UITableViewCell {

    @IBOutlet weak var trackView: UIView!
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var trackDuration: UILabel!
    @IBOutlet weak var playIcon: UIImageView!
    @IBOutlet weak var likeImage: UIImageView!
    
    var isFavorited: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        playIcon.isHidden = true
        
        trackImage.layer.cornerRadius = 10
        trackView.layer.cornerRadius = 10
        trackView.layer.borderWidth = 1
        trackView.layer.borderColor = UIColor.darkGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
