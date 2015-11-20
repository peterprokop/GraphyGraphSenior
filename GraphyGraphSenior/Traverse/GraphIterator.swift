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