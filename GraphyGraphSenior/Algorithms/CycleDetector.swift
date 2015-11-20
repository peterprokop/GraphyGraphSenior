//
//  CycleDetector.swift
//  GraphyGraphExample
//
//  Created by Peter Prokop on 19/11/15.
//  Copyright © 2015 Peter Prokop. All rights reserved.
//

import Foundation

private class ProbeIterator<V: Hashable, E: Hashable, G: Graph>: DepthFirstIterator<V, E, G>
{
    private var path: Array<V> = Array<V>()
    private var cycleSet: Set<V>?
    private var root: V?
    
    init(graph: G, cycleSet: Set<V>?, startVertex: V?)
    {
        super.init(graph: graph, startVertex: startVertex)
        self.root = startVertex
        self.cycleSet = cycleSet
    }
    
    // TODO: finish implementation
}

public enum CycleDetectorExceptions: ErrorType {
    case CycleDetectedException
}

public class CycleDetector<V: Hashable, E: Hashable, DG: DirectedGraph> {

    var graph: DG
    
    init(graph: DG) {
        self.graph = graph
    }
    
    public func detectCycles() -> Bool {
        do {
            try execute(nil, vertex: nil)
        } catch CycleDetectorExceptions.CycleDetectedException {
            return true
        } catch _ {
            
        }
    
        return false
    }
    
    public func detectCyclesContainingVertex(v: V) -> Bool {
        do {
            try execute(nil, vertex: v)
        } catch CycleDetectorExceptions.CycleDetectedException  {
            return true
        } catch _ {
            
        }

        return false
    }
    
    private func execute(s: Set<V>?, vertex: V?) throws {
        let iter = ProbeIterator<V, E, DG>(graph: graph, cycleSet: s, startVertex: vertex)
        
        while (iter.hasNext()) {
            iter.next();
        }
    }
}