//
//  Graphs.swift
//  GraphyGraphSeniorExample
//
//  Created by Peter Prokop on 20/11/15.
//  Copyright © 2015 Peter Prokop. All rights reserved.
//

import Foundation

public  class Graphs {
    
    /**
    * Gets the vertex opposite another vertex across an edge.
    *
    * @param g graph containing e and v
    * @param e edge in g
    * @param v vertex in g
    *
    * @return vertex opposite to v across e
    */

    public static func getOppositeVertex
        <V: Hashable, E: Hashable, G: Graph where G.V == V, G.E == E>
        (graph: G, edge: E, vertex: V)
        -> V
    {
        let source = graph.getEdgeSource(edge);
        let target = graph.getEdgeTarget(edge);
        if vertex == source {
            return target
        } else if vertex == target {
            return source
        } else {
            fatalError("no such vertex: \(vertex)")
        }
    }
}