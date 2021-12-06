//
//  AstroService.swift
//  AstroBrowser
//
//  Created by Khateeb H. on 12/3/21.
//

import Foundation
import Alamofire
import CoreData
import Network

enum EventServiceError: Error {
    case invalidManagedContext
}
protocol EventService_Protocol {
    func events(completion: @escaping (Result<[EventItem], Error>) -> Void)
}

class EventService: EventService_Protocol {
    static let shared = EventService()
    
    private let connectionMonitor = NWPathMonitor()
    private let httpClient: HTTPClient_Protocol
    private let jsonDecoder: JSONDecoder
    private var persistentContainer: NSPersistentContainer? = nil
    private var managedContext: NSManagedObjectContext? = nil
    var isOnline: Bool = false

    init(httpClient: HTTPClient_Protocol = HTTPClient()) {
        self.httpClient = httpClient
        self.jsonDecoder = JSONDecoder()
        self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        self.jsonDecoder.dateDecodingStrategy = .formatted(formatter)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        self.persistentContainer = appDelegate.persistentContainer
        self.managedContext = self.persistentContainer!.viewContext
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext else {
            fatalError("Failed to retrieve managed object context")
        }
        jsonDecoder.userInfo[codingUserInfoKeyManagedObjectContext] = self.managedContext
        
        connectionMonitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected!")
                self.isOnline = true
            } else {
                print("No connection.")
                self.isOnline = false
            }
        }
        
        let queue = DispatchQueue(label: "Monitor")
        connectionMonitor.start(queue: queue)
    }

    func events(completion: @escaping (Result<[EventItem], Error>) -> Void) {
        clearStorage()
        
        let request = HTTPRequest(url: URL(string: "https://raw.githubusercontent.com/phunware-services/dev-interview-homework/master/feed.json")!)
        httpClient.send(request: request) { result in
            switch result {
            case let .success(value):
                let items = try! self.jsonDecoder.decode([EventItem].self, from: value)
                do {
                    try self.managedContext?.save()
                    completion(.success(items))
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func eventsFromStorage(completion: @escaping (Result<[EventItem], Error>) -> Void) {
        guard let managedObjectContext = self.managedContext else {
            completion(.failure(EventServiceError.invalidManagedContext))
            return
        }
        let fetchRequest = NSFetchRequest<EventItem>(entityName: "EventItem")
        let sortDescriptor1 = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor1]
        do {
            let events = try managedObjectContext.fetch(fetchRequest)
            completion(.success(events))
        } catch let error {
            print(error)
            completion(.failure(error))
        }
    }

    func clearStorage() {
        guard let persistentContainer = self.persistentContainer else {
            print("Error: Invalid persistent container")
            return
        }
        let isInMemoryStore = persistentContainer.persistentStoreDescriptions.reduce(false) {
            return $0 ? true : $1.type == NSInMemoryStoreType
        }

        let managedObjectContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EventItem")
        // NSBatchDeleteRequest is not supported for in-memory stores
        if isInMemoryStore {
            do {
                let events = try managedObjectContext.fetch(fetchRequest)
                for event in events {
                    managedObjectContext.delete(event as! NSManagedObject)
                }
            } catch let error as NSError {
                print(error)
            }
        } else {
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try managedObjectContext.execute(batchDeleteRequest)
            } catch let error as NSError {
                print(error)
            }
        }
    }
}
