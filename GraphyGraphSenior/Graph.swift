//
//  Graph.swift
//  GraphyGraphExample
//
//  Created by Peter Prokop on 17/11/15.
//  Copyright © 2015 Peter Prokop. All rights reserved.
//

import Foundation

public protocol Graph {
    typealias V: Hashable
    typealias E: Hashable
    
    func getAllEdges(sourceVertex: V, targetVertex: V) -> Set<E>?
    func getEdge(sourceVertex: V, targetVertex: V) -> E?
    
    func getEdgeFactory() -> EdgeFactory<V, E>?
    func addEdge(sourceVertex: V, targetVertex: V) -> E?
    func addEdge(sourceVertex: V, targetVertex: V, e: E) -> Bool
    func addVertex(v: V) -> Bool
    func containsEdge(sourceVertex: V, targetVertex: V) -> Bool
    func containsEdge(e: E) -> Bool
    func containsVertex(v: V) -> Bool
    func edgeSet() -> Set<E>
    func edgesOf(v: V) -> Set<E>
    func removeAllEdges<T: CollectionType where T.Generator.Element == E>(edges: T) -> Bool
    func removeAllEdges(sourceVertex: V, targetVertex: V) -> Set<E>?
    func removeAllVertices<T: CollectionType where T.Generator.Element == V>(vertices: T) -> Bool
    func removeEdge(sourceVertex: V, targetVertex: V)
    func removeEdge(e: E) -> Bool
    func removeVertex(v: V) -> Bool
    func vertexSet() -> Set<V>
    func getEdgeSource(e: E) -> V
    func getEdgeTarget(e: E) -> V
    func getEdgeWeight(e: E) -> Double
}

public protocol DirectedGraph: Graph {
    typealias V: Hashable
    typealias E: Hashable
    
    func inDegreeOf(vertex: V) -> Int
    func incomingEdgesOf(vertex: V) -> Set<E>
    func outDegreeOf(vertex: V) -> Int
    func outgoingEdgesOf(vertex: V) -> Set<E>
}

public protocol UndirectedGraph: Graph {
    typealias V: Hashable
    typealias E: Hashable
    
    func degreeOf(vertex: V) -> Int
}