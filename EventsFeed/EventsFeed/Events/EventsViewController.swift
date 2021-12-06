//
//  ViewController.swift
//  EventsFeed
//
//  Created by Khateeb H. on 12/5/21.
//

import UIKit

final class EventsViewController: UIViewController {
    private static let eventCellIdentifier = "EventCell"
    private static let eventsHeaderViewIdentifier = "EventsHeaderView"

    @IBOutlet weak var collectionView: UICollectionView!
    private let viewModel: EventsViewModel = EventsViewModel()
    private let navigationPresenter = NavigationPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationPresenter.hideNavBar(from: self, isHidden: true)
        configureCollectionView()
        viewModel.fetchEvents { [unowned self]result in
            switch result {
            case .success(_):
                self.update()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configureCollectionView() {
        let layout = EventsLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 24
        layout.minimumLineSpacing = 16

        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .white
        collectionView.register(UINib(nibName: "EventCell", bundle: nil), forCellWithReuseIdentifier: type(of: self).eventCellIdentifier)
        collectionView.register(UINib(nibName: "EventsHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: type(of: self).eventsHeaderViewIdentifier)
    }
    
    private func update() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension EventsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.events.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: type(of: self).eventCellIdentifier, for: indexPath) as? EventCell {
            cell.event = viewModel.events[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: type(of: self).eventsHeaderViewIdentifier, for: indexPath) as! EventsHeaderView
        headerView.title = "Phun App"
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 96)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationPresenter.navigateToEventDetail(with: viewModel.events[indexPath.row], from: self, animated: true)
    }
}
