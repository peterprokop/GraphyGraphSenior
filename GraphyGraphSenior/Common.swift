//
//  Common.swift
//  GraphyGraphExample
//
//  Created by Peter Prokop on 20/11/15.
//  Copyright © 2015 Peter Prokop. All rights reserved.
//

import Foundation

@noreturn func abstractClassAssert() {
    fatalError("This is abstract class. This method shouldn't be called.")
}

// Needed to be able to init generic types
public protocol Initialisable {
    init()
}

extension Array where Element : Equatable {
    mutating func removeLastOccurrence(element: Element) -> Bool {
        for i in self.indices.reverse() where self[i] == element {
            self.removeAtIndex(i)
            return true
        }
        
        return false
    }
}