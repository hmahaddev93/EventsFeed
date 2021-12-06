//
//  EventDetailViewController.swift
//  EventsFeed
//
//  Created by Khateeb H. on 12/6/21.
//

import UIKit
import SDWebImage

class EventDetailViewController: UIViewController {

    var event: EventItem?
    private let navgationPresenter = NavigationPresenter()
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        update()
    }
    
    private func setupView() {
        shareButton.setTitle("", for: .normal)
        backButton.setTitle("", for: .normal)
        backButton.layer.masksToBounds = true
        backButton.layer.cornerRadius = 16
    }
    private func update() {
        guard let event = self.event else {
            print("Empty event")
            return
        }
        titleLabel.text = event.title
        dateLabel.text = event.date?.formatted()
        locationLabel.text = event.locationline1! + ", " + event.locationline2!
        descriptionLabel.text = event.descriptions
        guard let imageUrl = event.imageUrl else {
            imageView.image = UIImage(named: "placeholder_nomoon")
            return
        }
        imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder_nomoon"))
    }

    @IBAction func onBack(_ sender: Any) {
        navgationPresenter.pop(from: self, animted: true)
    }
    
    @IBAction func onShare(_ sender: Any) {
        
    }
}
