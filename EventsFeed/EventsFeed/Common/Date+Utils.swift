//
//  Date+Utils.swift
//  EventsFeed
//
//  Created by Khateeb H. on 12/6/21.
//

import Foundation

extension Date {
    func formatted() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy 'at' h:mm a"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }
}
