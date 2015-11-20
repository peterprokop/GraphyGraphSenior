//
//  AbstractGraphIterator.swift
//  GraphyGraphExample
//
//  Created by Peter Prokop on 20/11/15.
//  Copyright © 2015 Peter Prokop. All rights reserved.
//

import Foundation

public class AbstractGraphIterator<V: Hashable, E: Hashable>: GraphIterator<V, E> {
    
    private var traversalListeners = Array<TraversalListener<V, E>>()
    private var crossComponentTraversal = false
    private var reuseEvents = false
    private var nListeners = 0 // TODO: remove
    
    public func setCrossComponentTraversal(crossComponentTraversal: Bool) {
        self.crossComponentTraversal = crossComponentTraversal
    }
    
    public override func isCrossComponentTraversal() -> Bool {
        return crossComponentTraversal
    }
    
    public override func setReuseEvents(reuseEvents: Bool) {
        self.reuseEvents = reuseEvents
    }

    public override func isReuseEvents() -> Bool {
        return reuseEvents
    }

    public override func addTraversalListener(l: TraversalListener<V, E>) {
        if !traversalListeners.contains(l) {
            traversalListeners.append(l)
            nListeners = traversalListeners.count
        }
    }
    
    // TODO: check if used anywhere
    // @Override public func remove()
    
    public override func removeTraversalListener(l: TraversalListener<V, E>) {
        traversalListeners = traversalListeners.filter({ $0 != l })
        nListeners = traversalListeners.count
    }
    
    private func fireConnectedComponentFinished(e: ConnectedComponentTraversalEvent) {
        for l in traversalListeners {
            l.connectedComponentFinished(e)
        }
    }
    
    private func fireConnectedComponentStarted(e: ConnectedComponentTraversalEvent) {
        for l in traversalListeners {
            l.connectedComponentStarted(e)
        }
    }
    
    private func fireEdgeTraversed(e: EdgeTraversalEvent<V, E>) {
        for l in traversalListeners {
            l.edgeTraversed(e)
        }
    }
    
    private func fireVertexTraversed(e: VertexTraversalEvent<V>) {
        for l in traversalListeners {
            l.vertexTraversed(e)
        }
    }
    
    private func fireVertexFinished(e: VertexTraversalEvent<V>) {
        for l in traversalListeners {
            l.vertexFinished(e)
        }
    }
}