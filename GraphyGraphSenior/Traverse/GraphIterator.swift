//
//  GraphIterator.swift
//  GraphyGraphExample
//
//  Created by Peter Prokop on 20/11/15.
//  Copyright © 2015 Peter Prokop. All rights reserved.
//

import Foundation

/**
 Abstract class, was interface in original
*/
public class BaseIterator<T>: GeneratorType {
    public func next() -> T? {
        abstractClassAssert()
        return nil
    }
    
    public func hasNext() -> Bool {
        abstractClassAssert()
        return false
    }
}

public class GeneratorBasedIterator<T, GEN: GeneratorType where GEN.Element == T>: BaseIterator<T> {
    var cachedValue: T?
    var generator: GEN
    
    public override func next() -> T? {
        if cachedValue != nil {
            let tmp = cachedValue
            cachedValue = nil
            return tmp
        } else {
            return generator.next()
        }
    }
    
    public override func hasNext() -> Bool {
        
        if cachedValue != nil {
            return true
        } else {
            cachedValue = generator.next()
            return cachedValue != nil
        }
    }
    
    init(generator: GEN) {
        self.generator = generator
    }
}

/**
 Abstract class, was interface in original
 */
public class GraphIterator<V: Hashable, E: Hashable>: BaseIterator<V> {
    func isCrossComponentTraversal() -> Bool {
        abstractClassAssert()
        return false
    }
    
    func setReuseEvents(reuseEvents: Bool) {
        abstractClassAssert()
    }
    
    func isReuseEvents() -> Bool {
        abstractClassAssert()
        return false
    }
    
    func addTraversalListener(l: TraversalListener<V, E>) {
        abstractClassAssert()
    }
    
    // TODO: check if used anywhere
    //@Override public void remove();
    
    func removeTraversalListener(l: TraversalListener<V, E>) {
        abstractClassAssert()
    }

}