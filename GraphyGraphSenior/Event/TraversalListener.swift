//
//  TraversalListener.swift
//  GraphyGraphExample
//
//  Created by Peter Prokop on 20/11/15.
//  Copyright © 2015 Peter Prokop. All rights reserved.
//

import Foundation

public func ==<V: Hashable, E: Hashable>(lhs: TraversalListener<V, E>, rhs: TraversalListener<V, E>) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}

/**
 A listener on graph iterator or on a graph traverser.
 Abstract class. Was interface in original.
*/
public class TraversalListener<V: Hashable, E: Hashable>: Equatable {
    func connectedComponentFinished(e: ConnectedComponentTraversalEvent) {
        abstractClassAssert()
    }
    
    func connectedComponentStarted(e: ConnectedComponentTraversalEvent) {
        abstractClassAssert()
    }
    
    func edgeTraversed(e: EdgeTraversalEvent<V, E>) {
        abstractClassAssert()
    }

    func vertexTraversed(e: VertexTraversalEvent<V>) {
        abstractClassAssert()
    }

    func vertexFinished(e: VertexTraversalEvent<V>) {
        abstractClassAssert()
    }
}