//
//  EventCell.swift
//  EventsFeed
//
//  Created by Khateeb H. on 12/6/21.
//

import UIKit
import SDWebImage

class EventCell: UICollectionViewCell {

    var event: EventItem! {
        didSet {
            titleLabel.text = event.title
            locationLabel.text = event.locationline1! + ", " + event.locationline2!
            descriptionLabel.text = event.descriptions
            dateLabel.text = event.date?.formatted()
            guard let imageUrl = event.imageUrl else {
                imageView.image = UIImage(named: "placeholder_nomoon")
                return
            }
            imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder_nomoon"))
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var blackOverlay: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageView.layer.cornerRadius = 8
        blackOverlay.layer.cornerRadius = 8
    }

}
