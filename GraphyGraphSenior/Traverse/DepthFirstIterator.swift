//
//  DepthFirstIterator.swift
//  GraphyGraphExample
//
//  Created by Peter Prokop on 20/11/15.
//  Copyright © 2015 Peter Prokop. All rights reserved.
//

import Foundation

public enum DepthFirstIteratorSentinelUnion<V: Equatable>: Equatable {
    case Sentinel
    case Some(V)
}

public func ==<V: Equatable>(lhs: DepthFirstIteratorSentinelUnion<V>, rhs: DepthFirstIteratorSentinelUnion<V>) -> Bool {
    
    switch (lhs, rhs) {
    case (.Sentinel, .Sentinel):
        return true
    case (.Some(let l), .Some(let r)):
        return (l == r)
    case _:
        return false
    }
}



/**
 A depth-first iterator for a directed and an undirected graph. For this    
 iterator to work correctly the graph must not be modified during iteration.
 Currently there are no means to ensure that, nor to fail-fast. The results of
 such modifications are undefined.
*/
public class DepthFirstIterator<V: Hashable, E: Hashable, G: Graph where G.V == V, G.E == E>
    : CrossComponentIterator<V, E, CrossComponentIteratorVisitColor, G>
{

    private var stack = Array<DepthFirstIteratorSentinelUnion<V>>()
    
    // TODO: check if needed
    //private transient TypeUtil<V> vertexTypeDecl = null;
    
    public convenience init(graph: G) {
        self.init(graph: graph, startVertex: nil)
    }
    
    public override init(graph: G, startVertex: V?) {
        super.init(graph: graph, startVertex: startVertex)
    }
    
    override func isConnectedComponentExhausted() -> Bool
    {
        for (;;) {
            if stack.isEmpty {
                return true
            }
            if stack.last != DepthFirstIteratorSentinelUnion.Sentinel {
                // Found a non-sentinel.
                return false
            }

            // Found a sentinel:  pop it, record the finish time,
            // and then loop to check the rest of the stack.

            // Pop null we peeked at above.
            stack.removeLast()

            // This will pop corresponding vertex to be recorded as finished.
            recordFinish()
        }
    }
    
    override func encounterVertex(vertex: V, edge: E?) {
        putSeenData(vertex, data: CrossComponentIteratorVisitColor.WHITE)
        stack.append(.Some(vertex))
    }
    
    override func encounterVertexAgain(vertex: V, edge: E?) {
        let color = getSeenData(vertex)
        if color != CrossComponentIteratorVisitColor.WHITE {
            // We've already visited this vertex; no need to mess with the
            // stack (either it's BLACK and not there at all, or it's GRAY
            // and therefore just a sentinel).
            return;
        }
        
        // Since we've encountered it before, and it's still WHITE, it
        // *must* be on the stack.  Use removeLastOccurrence on the
        // assumption that for typical topologies and traversals,
        // it's likely to be nearer the top of the stack than
        // the bottom of the stack.
        let found = stack.removeLastOccurrence(.Some(vertex))

        
        assert(found)
        stack.append(.Some(vertex))
    }
    
    /**
     * @see CrossComponentIterator#provideNextVertex()
     */
    override func provideNextVertex() -> V {
        var v: V
        outerLoop: for (;;) {
            let o = stack.removeLast()
            
            switch o {
            case .Sentinel:
                // This is a finish-time sentinel we previously pushed.
                recordFinish()
                // Now carry on with another pop until we find a non-sentinel
            case .Some(let vv):
                // Got a real vertex to start working on
                v = vv
                break outerLoop
            }
        }

        // Push a sentinel for v onto the stack so that we'll know
        // when we're done with it.
        stack.append(.Some(v))
        stack.append(.Sentinel)
        putSeenData(v, data: CrossComponentIteratorVisitColor.GRAY)
        return v
    }
    
    func recordFinish() {
        let container = stack.removeLast()
        
        switch container {
        case .Sentinel:
            assertionFailure("there shouldn't be sentinel at this point")
        case .Some(let v):
            putSeenData(v, data: CrossComponentIteratorVisitColor.BLACK);
            finishVertex(v)
        }
    }

    /**
      Retrieves the LIFO stack of vertices which have been encountered but not
      yet visited (WHITE). This stack also contains <em>sentinel</em> entries
      representing vertices which have been visited but are still GRAY. A
      sentinel entry is a sequence (v, SENTINEL), whereas a non-sentinel entry
      is just (v).
     
      - return stack
     */
    public func getStack() -> Array<DepthFirstIteratorSentinelUnion<V>> {
        return stack
    }
}