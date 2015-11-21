//
//  CycleDetector.swift
//  GraphyGraphExample
//
//  Created by Peter Prokop on 19/11/15.
//  Copyright © 2015 Peter Prokop. All rights reserved.
//

import Foundation

private class ProbeIterator<V: Hashable, E: Hashable, G: Graph where G.V == V, G.E == E>: DepthFirstIterator<V, E, G>
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
    
    override func encounterVertexAgain(vertex: V, edge: E?) {
        
    }
    
    // TODO: finish implementation
}

public enum CycleDetectorExceptions: ErrorType {
    case CycleDetectedException
}

public class CycleDetector<V: Hashable, E: Hashable, DG: DirectedGraph where DG.V == V, DG.E == E> {

    var graph: DG
    
    public init(graph: DG) {
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
    
    /**
      Finds the vertex set for the subgraph of all cycles.
    
      - return set of all vertices which participate in at least one cycle in
      this graph
     */
    /*
    public func findCycles() -> Set<V>
    {
        // ProbeIterator can't be used to handle this case,
        // so use StrongConnectivityAlgorithm instead.
        StrongConnectivityAlgorithm<V, E> inspector =
            new KosarajuStrongConnectivityInspector<V, E>(graph);
        List<Set<V>> components = inspector.stronglyConnectedSets();

        // A vertex participates in a cycle if either of the following is
        // true:  (a) it is in a component whose size is greater than 1
        // or (b) it is a self-loop

        Set<V> set = new HashSet<V>();
        for component in components {
            if (component.size() > 1) {
                // cycle
                set.addAll(component);
            } else {
                V v = component.iterator().next();
                if (graph.containsEdge(v, v)) {
                    // self-loop
                    set.add(v);
                }
            }
        }

        return set;
    }
    */
     
    // TODO: finish
    
    private func execute(s: Set<V>?, vertex: V?) throws {
        let iter = ProbeIterator<V, E, DG>(graph: graph, cycleSet: s, startVertex: vertex)
        
        while (iter.hasNext()) {
            iter.next();
        }
    }
    
    // TODO: finish
}