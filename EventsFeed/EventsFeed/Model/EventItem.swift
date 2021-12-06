//
//  Event.swift
//  EventsFeed
//
//  Created by Khateeb H. on 12/5/21.
//

import Foundation
import CoreData

class EventItem: NSManagedObject, Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case descriptions = "description"
        case imageUrl = "image"
        case timestamp
        case date
        case phone
        case locationline1
        case locationline2
    }

    // MARK: - Core Data Managed Object
    @NSManaged var id: NSNumber
    @NSManaged var title: String?
    @NSManaged var descriptions: String?
    @NSManaged var imageUrl: String?
    @NSManaged var timestamp: Date?
    @NSManaged var date: Date?
    @NSManaged var phone: String?
    @NSManaged var locationline1: String?
    @NSManaged var locationline2: String?

    // MARK: - Decodable
    required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "EventItem", in: managedObjectContext) else {
                fatalError("Failed to decode User")
        }

        self.init(entity: entity, insertInto: managedObjectContext)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int16.self , forKey: .id)! as NSNumber
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.descriptions = try container.decodeIfPresent(String.self, forKey: .descriptions)
        self.imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        self.timestamp = try container.decodeIfPresent(Date.self, forKey: .timestamp)
        self.date = try container.decodeIfPresent(Date.self, forKey: .date)
        self.phone = try container.decodeIfPresent(String.self, forKey: .phone)
        self.locationline1 = try container.decodeIfPresent(String.self, forKey: .locationline1)
        self.locationline2 = try container.decodeIfPresent(String.self, forKey: .locationline2)
    }

    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id.intValue, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(descriptions, forKey: .descriptions)
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(date, forKey: .date)
        try container.encode(phone, forKey: .phone)
        try container.encode(locationline1, forKey: .locationline1)
        try container.encode(locationline2, forKey: .locationline2)
    }
}

public extension CodingUserInfoKey {
    // Helper property to retrieve the Core Data managed object context
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}
