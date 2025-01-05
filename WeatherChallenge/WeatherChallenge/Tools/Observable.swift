//
//  Observable.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 23/12/2024.
//

import Foundation

// TODO: This should be moved to a Tools module and imported everywhere to be used
// WIP: Can I simplify/update this? Let the observers keep the reference. So the Observable doesn't know who obsertves it
final class Observable<T> {
    typealias ObserverBlock = (_ newValue: T, _ oldValue: T) -> Void
    
    final class ObserverEntry {
        weak var observer: AnyObject?
        let block: ObserverBlock
        
        init(
            observer: AnyObject,
            block: @escaping ObserverBlock
        ) {
            self.observer = observer
            self.block = block
        }
    }
    
    private var observers = [ObserverEntry]()
    
    init(_ value: T) {
        self.value = value
    }
    var value: T {
        didSet {
            self.observers.forEach { observerEntry in
                guard let _ = observerEntry.observer else { return }
                observerEntry.block(value, oldValue)
            }
        }
    }
    
    func subscribe(observer: AnyObject, block: @escaping ObserverBlock) {
        self.observers.append(
            ObserverEntry(
                observer: observer,
                block: block
            )
        )
    }
    
    func unsubscribe(observer: AnyObject) {
        let filtered = observers.filter { observerEntry in
            return observerEntry.observer !== observer
        }
        
        self.observers = filtered
    }
}
