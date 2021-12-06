//
//  EventsHeaderView.swift
//  EventsFeed
//
//  Created by Khateeb H. on 12/6/21.
//

import UIKit

class EventsHeaderView: UICollectionReusableView {
    
    var title: String! {
        didSet {
            titleLabel.text = title
        }
    }

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
