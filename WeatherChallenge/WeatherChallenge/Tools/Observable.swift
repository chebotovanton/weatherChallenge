//
//  Observable.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 23/12/2024.
//

import Foundation

// WIP: Move to a Tools framework?
// WIP: Can I simplify/update this?
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
