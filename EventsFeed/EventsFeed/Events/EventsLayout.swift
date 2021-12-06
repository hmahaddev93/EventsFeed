//
//  EventsLayout.swift
//  EventsFeed
//
//  Created by Khateeb H. on 12/6/21.
//

import UIKit

final class EventsLayout: UICollectionViewFlowLayout {

    var numberOfItemsPerRow : Int {
        get{
            var value = 0
            if UIDevice.current.userInterfaceIdiom == .phone {
                value = 1
            } else {
                value = 2
            }
            return value
        }
        set {
            self.invalidateLayout()
        }
    }

    override func prepare() {
        super.prepare()
        if self.collectionView != nil {
            var newItemSize = self.itemSize
            let itemsPerRow = max(self.numberOfItemsPerRow, 1)
            let totalSpacing = self.minimumInteritemSpacing * CGFloat(itemsPerRow - 1)
            let newWidth = (self.collectionView!.bounds.size.width - self.sectionInset.left - self.sectionInset.right - totalSpacing) / CGFloat(itemsPerRow)
            newItemSize.width = max(newItemSize.width,newWidth)
            newItemSize.height = 210
            self.itemSize = newItemSize
        }
    }
}
