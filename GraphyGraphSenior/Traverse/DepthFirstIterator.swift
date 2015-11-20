//
//  DepthFirstIterator.swift
//  GraphyGraphExample
//
//  Created by Peter Prokop on 20/11/15.
//  Copyright © 2015 Peter Prokop. All rights reserved.
//

import Foundation

public let DepthFirstIteratorSENTINEL = NSObject()

/**
 A depth-first iterator for a directed and an undirected graph. For this    
 iterator to work correctly the graph must not be modified during iteration.
 Currently there are no means to ensure that, nor to fail-fast. The results of
 such modifications are undefined.
*/
public class DepthFirstIterator<V: Hashable, E: Hashable, G: Graph>: CrossComponentIterator<V, E, CrossComponentIteratorVisitColor, G> {

    private let stack = Array<AnyObject>()
    
    // TODO: check if needed
    //private transient TypeUtil<V> vertexTypeDecl = null;
    
    public convenience init(graph: G) {
        self.init(graph: graph, startVertex: nil)
    }
    
    public override init(graph: G, startVertex: V?) {
        super.init(graph: graph, startVertex: startVertex)
    }
}