//
//  EventsViewModel.swift
//  EventsFeed
//
//  Created by Khateeb H. on 12/5/21.
//

import Foundation
import Network

final class EventsViewModel {
    var events = [EventItem]()
    private let eventService = EventService.shared
    func fetchEvents(completion: @escaping (Result<[EventItem], Error>) -> Void) {
        if eventService.isOnline {
            eventService.events { result in
                switch result {
                case .success(let events):
                    self.events = events
                    completion(.success(events))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            eventService.eventsFromStorage { result in
                switch result {
                case .success(let events):
                    self.events = events
                    completion(.success(events))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
