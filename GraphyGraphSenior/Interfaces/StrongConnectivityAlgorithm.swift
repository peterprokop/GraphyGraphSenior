//
//  StrongConnectivityAlgorithm.swift
//  GraphyGraphSeniorExample
//
//  Created by Peter Prokop on 20/11/15.
//  Copyright © 2015 Peter Prokop. All rights reserved.
//

import Foundation

/**
  A protocol to the StrongConnectivityInspector algorithm classes. These classes verify whether the graph is
  strongly connected.

  - param <V>   vertex concept type
  - param <E>   edge concept type
 */
public protocol StrongConnectivityAlgorithm {
    typealias V: Hashable
    typealias E: Hashable
    typealias DG: DirectedGraph
    
    /**
     * Returns the graph inspected by the StrongConnectivityAlgorithm.
     *
     * @return the graph inspected by this StrongConnectivityAlgorithm
     */
    func getGraph() -> DG

    /**
     * Returns true if the graph of this <code>
     * StrongConnectivityAlgorithm</code> instance is strongly connected.
     *
     * @return true if the graph is strongly connected, false otherwise
     */
    func isStronglyConnected() -> Bool

    /**
     * Computes a {@link List} of {@link Set}s, where each set contains vertices
     * which together form a strongly connected component within the given
     * graph.
     *
     * @return <code>List</code> of <code>Set</code> s containing the strongly
     * connected components
     */
    func stronglyConnectedSets() -> Array<Set<V>>

    /**
     * <p>Computes a list of {@link DirectedSubgraph}s of the given graph. Each
     * subgraph will represent a strongly connected component and will contain
     * all vertices of that component. The subgraph will have an edge (u,v) iff
     * u and v are contained in the strongly connected component.</p>
     *
     *
     * @return a list of subgraphs representing the strongly connected
     * components
     */
    func stronglyConnectedSubgraphs<DG:DirectedGraph where DG.E == E, DG.V == V>() -> Array<DirectedSubgraph<V, E, DG>>

}
