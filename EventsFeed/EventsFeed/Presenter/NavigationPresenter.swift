//
//  NavigationPresenter.swift
//  EventsFeed
//
//  Created by Khateeb H. on 12/6/21.
//

import UIKit

protocol NavigationPresenter_Proto {
    func navigate(from: UIViewController, destination: UIViewController, title: String?, animated: Bool)
    func hideNavBar(from: UIViewController, isHidden: Bool)
    func pop(from: UIViewController, animted: Bool)
}

class NavigationPresenter: NavigationPresenter_Proto {
    
    func navigate(from: UIViewController, destination: UIViewController, title: String?, animated: Bool) {
        if let navController = from.navigationController {
            destination.title = title
            navController.pushViewController(destination, animated: animated)
        }
        else {
            destination.title = title
            from.present(UINavigationController(rootViewController: destination), animated: animated)
        }
    }
    
    func pop(from: UIViewController, animted: Bool) {
        if let navController = from.navigationController {
            navController.popViewController(animated: animted)
        }
    }
    
    func hideNavBar(from: UIViewController, isHidden: Bool) {
        if let navController = from.navigationController {
            navController.isNavigationBarHidden = isHidden
        }
    }
    
    func navigateToEventDetail(with event: EventItem, from: UIViewController, animated: Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EventDetailViewController") as! EventDetailViewController
        vc.event = event
        navigate(from: from, destination: vc, title: nil, animated: true)
    }
}


