//
//  SimpleGraph.swift
//  GraphyGraphSeniorExample
//
//  Created by Peter Prokop on 20/11/15.
//  Copyright © 2015 Peter Prokop. All rights reserved.
//

import Foundation

public class SimpleGraph<V: Hashable, E: Hashable where E: Initialisable>: AbstractBaseGraph<V, E>, _UndirectedGraph {
    init(edgeFactory: EdgeFactory<V, E>) {
        super.init(edgeFactory: edgeFactory, allowMultipleEdges: false, allowLoops: false)
    }
    
    convenience override init() {
        self.init(edgeFactory: ClassBasedEdgeFactory<V,E>())
    }
    
    // TODO: add builder funcs
    
    override public func crossComponentIteratorEdgesOf(v: V) -> Set<E> {
        return edgesOf(v)
    }
    
    override public func degreeOf(vertex: V) -> Int {
        return super.degreeOf(vertex)
    }
}