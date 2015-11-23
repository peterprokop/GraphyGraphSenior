//
//  DefaultDirectedGraph.swift
//  GraphyGraphExample
//
//  Created by Peter Prokop on 17/11/15.
//  Copyright © 2015 Peter Prokop. All rights reserved.
//

import Foundation

public class DefaultDirectedGraph<V: Hashable, E: Hashable where E: Initialisable>
    : AbstractBaseGraph<V, E>, DirectedGraph
{
    public func inDegreeOf(vertex: V) -> Int {
        return specifics!.inDegreeOf(vertex)
    }
    
    override public func incomingEdgesOf(vertex: V) -> Set<E> {
        return specifics!.incomingEdgesOf(vertex)
    }
    
    override public func outDegreeOf(vertex: V) -> Int {
        return specifics!.outDegreeOf(vertex)
    }
    
    override public func outgoingEdgesOf(vertex: V) -> Set<E> {
        return specifics!.outgoingEdgesOf(vertex)
    }
    
    override convenience init() {
        self.init(edgeFactory: ClassBasedEdgeFactory<V, E>())
    }

    init(edgeFactory: EdgeFactory<V, E>) {
        super.init(edgeFactory: edgeFactory, allowMultipleEdges: false, allowLoops: true)
    }
    
    override public func crossComponentIteratorEdgesOf(v: V) -> Set<E> {
        return outgoingEdgesOf(v)
    }
}