//
//  GraphyGraph.swift
//  GraphyGraphExample
//
//  Created by Peter Prokop on 15/11/15.
//  Copyright © 2015 Peter Prokop. All rights reserved.
//

import Foundation


class Specifics<V: Hashable, E: Hashable> {
    
    func addVertex(vertex: V) { abstractClassAssert() }
    
    // Wasn't present in original, but we need this since we can't mutate set, returned from getVertexSet
    func removeVertex(vertex: V) { abstractClassAssert() }
    
    func getVertexSet() -> Set<V> { abstractClassAssert()}
    
    func getAllEdges(sourceVertex: V, targetVertex: V) -> Set<E>? { abstractClassAssert() }
    
    func getEdge(sourceVertex: V, targetVertex: V) -> E? { abstractClassAssert() }
    
    func addEdgeToTouchingVertices(e: E) { abstractClassAssert() }
    
    func degreeOf(vertex: V) -> Int { abstractClassAssert() }
    
    func edgesOf(vertex: V) -> Set<E> { abstractClassAssert() }
    
    func inDegreeOf(vertex: V) -> Int { abstractClassAssert() }
    
    func incomingEdgesOf(vertex: V) -> Set<E> { abstractClassAssert() }
    
    func outDegreeOf(vertex: V) -> Int { abstractClassAssert() }
    
    func outgoingEdgesOf(vertex: V) -> Set<E> { abstractClassAssert() }
    
    func removeEdgeFromTouchingVertices(e: E) { abstractClassAssert() }
}

private class UndirectedEdgeContainer<V: Hashable, E: Hashable> {
    var vertexEdges: Set<E>
    var unmodifiableVertexEdges: Set<E>?
    
    init(edgeSetFactory: EdgeSetFactory<V, E>, vertex: V) {
        vertexEdges = edgeSetFactory.createEdgeSet(vertex)
    }
    
    func getUnmodifiableVertexEdges() -> Set<E> {
        // TODO: !!! make unmodifiable
        return vertexEdges
    }
    
    func addEdge(e: E) {
        vertexEdges.insert(e)
    }
    
    func edgeCount() -> Int {
        return vertexEdges.count
    }

    func removeEdge(e: E) {
        vertexEdges.remove(e)
    }
}

class DirectedEdgeContainer<V: Hashable, E: Hashable> {
    var incoming: Set<E>
    var outgoing: Set<E>
    private var unmodifiableIncoming: Set<E>?
    private var unmodifiableOutgoing: Set<E>?
    
    init(edgeSetFactory: EdgeSetFactory<V, E>, vertex: V) {
        incoming = edgeSetFactory.createEdgeSet(vertex)
        outgoing = edgeSetFactory.createEdgeSet(vertex)
    }
    
    /**
     * A lazy build of unmodifiable incoming edge set.
     *
     * @return
     */
    func getUnmodifiableIncomingEdges() -> Set<E>
    {
        if (unmodifiableIncoming == nil) {
            unmodifiableIncoming = incoming
        }

        return unmodifiableIncoming!
    }

    /**
     * A lazy build of unmodifiable outgoing edge set.
     *
     * @return
     */
    func getUnmodifiableOutgoingEdges() -> Set<E>
    {
        if (unmodifiableOutgoing == nil) {
            unmodifiableOutgoing = outgoing
        }

        return unmodifiableOutgoing!
    }

    func addIncomingEdge(e: E)
    {
        incoming.insert(e)
    }

    func addOutgoingEdge(e: E)
    {
        outgoing.insert(e)
    }

    func removeIncomingEdge(e: E)
    {
        incoming.remove(e)
    }

    func removeOutgoingEdge(e: E)
    {
        outgoing.remove(e)
    }
}

private class DirectedSpecifics<V: Hashable, E: Hashable>: Specifics<V, E> {
    typealias VertexMapValueTA = DirectedEdgeContainer<V, E>?
    typealias VertexMapDirectedTA = Dictionary<V, VertexMapValueTA>
    
    let NOT_IN_DIRECTED_GRAPH = "no such operation in a directed graph"

    weak var parentGraph: AbstractBaseGraph<V, E>?
    
    private var vertexMapDirected: VertexMapDirectedTA

    convenience init(parentGraph: AbstractBaseGraph<V, E>) {
        self.init(vertexMap: VertexMapDirectedTA(), parentGraph: parentGraph)
    }

    init(vertexMap: VertexMapDirectedTA, parentGraph: AbstractBaseGraph<V, E>) {
        self.vertexMapDirected = vertexMap
        self.parentGraph = parentGraph
    }

    override func addVertex(vertex: V) {
        // add with a lazy edge container entry
        vertexMapDirected[vertex] = nil as VertexMapValueTA  // "as" needed to actually store nil
    }
    
    override func removeVertex(vertex: V) {
        vertexMapDirected.removeValueForKey(vertex)
    }

    override func getVertexSet() -> Set<V>
    {
        return Set(vertexMapDirected.keys)
    }

    /**
     * @see Graph#getAllEdges(Object, Object)
     */
    override func getAllEdges(sourceVertex: V, targetVertex: V) -> Set<E>?
    {
        if parentGraph!.containsVertex(sourceVertex)
            && parentGraph!.containsVertex(targetVertex)
        {
            var edges = Set<E>()

            let ec = getEdgeContainer(sourceVertex)

            let outgoing = ec.outgoing
            for e in outgoing {
                if parentGraph!.getEdgeTarget(e) == targetVertex {
                    edges.insert(e)
                }
            }
            
            
            return edges
        }

        return nil
    }

    /**
     * @see Graph#getEdge(Object, Object)
     */
    override func getEdge(sourceVertex: V, targetVertex: V) -> E?
    {
        if parentGraph!.containsVertex(sourceVertex)
            && parentGraph!.containsVertex(targetVertex)
        {
            let ec = getEdgeContainer(sourceVertex)

            let outgoing = ec.outgoing
            for e in outgoing {
                if parentGraph!.getEdgeTarget(e) == targetVertex {
                    return e
                }
            }
            
        }

        return nil
    }

    override func addEdgeToTouchingVertices(e: E)
    {
        let source = parentGraph!.getEdgeSource(e)
        let target = parentGraph!.getEdgeTarget(e)

        getEdgeContainer(source).addOutgoingEdge(e)
        getEdgeContainer(target).addIncomingEdge(e)
    }

    /**
     * @see UndirectedGraph#degreeOf(Object)
     */
    override func degreeOf(vertex: V) -> Int
    {
        fatalError(NOT_IN_DIRECTED_GRAPH)
    }

    /**
     * @see Graph#edgesOf(Object)
     */
    override func edgesOf(vertex: V) -> Set<E>
    {
        var inAndOut = Set<E>(getEdgeContainer(vertex).incoming)
        inAndOut.unionInPlace(getEdgeContainer(vertex).outgoing)

        // we have two copies for each self-loop - remove one of them.
        if parentGraph!.allowingLoops {
            if var loops = getAllEdges(vertex, targetVertex: vertex) {
                var edgesToRemove = Set<E>()
                
                for e in inAndOut {
                    if loops.contains(e) {
                        edgesToRemove.insert(e)
                        loops.remove(e) // so we remove it only once
                    }
                }
                
                inAndOut.subtractInPlace(edgesToRemove)
            }
        }

        // TODO: make unmodifiable
        return inAndOut
    }

    /**
     * @see DirectedGraph#inDegreeOf(Object)
     */
    override func inDegreeOf(vertex: V) -> Int
    {
        return getEdgeContainer(vertex).incoming.count
    }

    /**
     * @see DirectedGraph#incomingEdgesOf(Object)
     */
    override func incomingEdgesOf(vertex: V) -> Set<E>
    {
        return getEdgeContainer(vertex).getUnmodifiableIncomingEdges();
    }

    /**
     * @see DirectedGraph#outDegreeOf(Object)
     */
    override func outDegreeOf(vertex: V) -> Int
    {
        return getEdgeContainer(vertex).outgoing.count
    }

    /**
     * @see DirectedGraph#outgoingEdgesOf(Object)
     */
    override func outgoingEdgesOf(vertex: V) -> Set<E>
    {
        return getEdgeContainer(vertex).getUnmodifiableOutgoingEdges();
    }

    override func removeEdgeFromTouchingVertices(e: E)
    {
        let source = parentGraph!.getEdgeSource(e)
        let target = parentGraph!.getEdgeTarget(e)

        getEdgeContainer(source).removeOutgoingEdge(e);
        getEdgeContainer(target).removeIncomingEdge(e);
    }
    
    /**
     * A lazy build of edge container for specified vertex.
     *
     * @param vertex a vertex in this graph.
     *
     * @return EdgeContainer
     */
    func getEdgeContainer(vertex: V) -> DirectedEdgeContainer<V, E>
    {
        parentGraph!.assertVertexExist(vertex)

        var ec = vertexMapDirected[vertex]

        if ec == nil || ec! == nil {
            ec = DirectedEdgeContainer<V, E>(edgeSetFactory: parentGraph!.edgeSetFactory!,
                vertex: vertex)
            vertexMapDirected[vertex] = ec
        }

        return ec!!
    }
}

private class UndirectedSpecifics<V: Hashable, E: Hashable>: Specifics<V, E> {
    
    typealias VertexMapValueTA = UndirectedEdgeContainer<V, E>?
    typealias VertexMapUndirectedTA = Dictionary<V, VertexMapValueTA>
    
    let NOT_IN_UNDIRECTED_GRAPH = "no such operation in an undirected graph"
    
    weak var parentGraph: AbstractBaseGraph<V, E>?
    private var vertexMapUndirected: VertexMapUndirectedTA
    
    convenience init(parentGraph: AbstractBaseGraph<V, E>) {
        self.init(vertexMap: VertexMapUndirectedTA(), parentGraph: parentGraph)
    }
    
    init(vertexMap: VertexMapUndirectedTA, parentGraph: AbstractBaseGraph<V, E>) {
        self.vertexMapUndirected = vertexMap
        self.parentGraph = parentGraph
    }
    
    override func addVertex(vertex: V) {
        vertexMapUndirected[vertex] = nil as VertexMapValueTA  // "as" needed to actually store nil
    }
    
    override func removeVertex(vertex: V) {
        vertexMapUndirected.removeValueForKey(vertex)
    }
    
    override func getVertexSet() -> Set<V> {
        return Set(vertexMapUndirected.keys)
    }
    
    override func getAllEdges(sourceVertex: V, targetVertex: V) -> Set<E>? {
        
        if parentGraph!.containsVertex(sourceVertex)
            && parentGraph!.containsVertex(targetVertex)
        {
            var edges = Set<E>()
            let vertexEdges = getEdgeContainer(sourceVertex).vertexEdges
            
            for e in vertexEdges {
                let equal = isEqualsStraightOrInverted(sourceVertex,
                    targetVertex: targetVertex,
                    edge: e)
                
                if equal {
                    edges.insert(e)
                }
            }
            
            return edges
        }
        
        return nil
    }
    
    override func getEdge(sourceVertex: V, targetVertex: V) -> E? {
        if vertexMapUndirected.keys.contains(sourceVertex)
            && vertexMapUndirected.keys.contains(targetVertex)
        {
            let vertexEdges = getEdgeContainer(sourceVertex).vertexEdges
            
            for e in vertexEdges {
                let equal = isEqualsStraightOrInverted(sourceVertex, targetVertex: targetVertex, edge: e)
                
                if equal {
                    return e
                }
            }
        }
        
        return nil
    }
    
    func isEqualsStraightOrInverted(sourceVertex: V, targetVertex: V, edge: E) -> Bool {
        let equalStraight = (sourceVertex == parentGraph!.getEdgeSource(edge)
            && targetVertex == parentGraph!.getEdgeTarget(edge))
        
        let equalInverted = (sourceVertex == parentGraph!.getEdgeTarget(edge)
            && targetVertex == parentGraph!.getEdgeSource(edge))
        
        return equalStraight || equalInverted
    }

    override func addEdgeToTouchingVertices(e: E) {
       let source = parentGraph!.getEdgeSource(e)
       let target = parentGraph!.getEdgeTarget(e)
        
        getEdgeContainer(source).addEdge(e)
        
        if source != target {
            getEdgeContainer(target).addEdge(e)
        }
    }
    
    override func degreeOf(vertex: V) -> Int {
        if parentGraph!.allowingLoops {
            var degree = 0
            let edges = getEdgeContainer(vertex).vertexEdges
            
            for e in edges {
                if parentGraph!.getEdgeSource(e) == parentGraph!.getEdgeTarget(e) {
                    degree += 2
                } else {
                    degree += 1
                }
            }
            
            return degree
        } else {
            return getEdgeContainer(vertex).edgeCount()
        }
    }
    
    override func edgesOf(vertex: V) -> Set<E> {
        return getEdgeContainer(vertex).getUnmodifiableVertexEdges()
    }
    
    override func inDegreeOf(vertex: V) -> Int {
        fatalError(NOT_IN_UNDIRECTED_GRAPH)
    }
    
    override func incomingEdgesOf(vertex: V) -> Set<E> {
        fatalError(NOT_IN_UNDIRECTED_GRAPH)
    }
    
    override func outDegreeOf(vertex: V) -> Int {
        fatalError(NOT_IN_UNDIRECTED_GRAPH)
    }
    
    override func outgoingEdgesOf(vertex: V) -> Set<E> {
        fatalError(NOT_IN_UNDIRECTED_GRAPH)
    }
    
    override func removeEdgeFromTouchingVertices(e: E) {
        let source = parentGraph!.getEdgeSource(e)
        let target = parentGraph!.getEdgeTarget(e)
        
        getEdgeContainer(source).removeEdge(e)
        
        if source != target {
            getEdgeContainer(target).removeEdge(e)
        }
    }
    
    func getEdgeContainer(vertex: V) -> UndirectedEdgeContainer<V, E> {
        parentGraph!.assertVertexExist(vertex)
        var ec = vertexMapUndirected[vertex]
        if ec == nil || ec! == nil {
            ec =
                UndirectedEdgeContainer<V, E>(
                    edgeSetFactory: parentGraph!.edgeSetFactory!,
                    vertex: vertex)
            vertexMapUndirected[vertex] = ec
        }
        
        return ec!!
    }
}

class ArrayListFactory<V: Hashable, E: Hashable>: EdgeSetFactory<V, E> {
    override func createEdgeSet(vertex: V) -> Set<E>
    {
        // NOTE: original used 1 as minimum capacity, but Swift Set needs that to be power of 2
        // TODO: find suitable replacement for Java's ArrayUnenforcedSet
        return Set<E>(minimumCapacity: 2)
    }
}

public class AbstractBaseGraph<V: Hashable, E: Hashable>: Graph {
    let LOOPS_NOT_ALLOWED = "loops not allowed"

    var allowingLoops = false
    private var allowingMultipleEdges = false
    
    private var edgeFactory: EdgeFactory<V, E>?
    private var edgeSetFactory: EdgeSetFactory<V, E>?
    private var edgeMap = Dictionary<E, IntrusiveEdge<V>>()
    
    var unmodifiableEdgeSet: Set<E>?
    var unmodifiableVertexSet: Set<V>?

    var specifics: Specifics<V, E>?

    //TODO: check if needed
    //private transient TypeUtil<V> vertexTypeDecl = null;
    
    
    init() {
        if self.dynamicType === AbstractBaseGraph.self {
            abstractClassAssert()
        }
    }
    
    init(edgeFactory: EdgeFactory<V,E>, allowMultipleEdges: Bool, allowLoops: Bool) {
        self.edgeFactory = edgeFactory
        self.allowingLoops = allowLoops
        self.allowingMultipleEdges = allowMultipleEdges
        
        self.specifics = createSpecifics()
        
        self.edgeSetFactory = ArrayListFactory<V, E>()
    }
    
    private func createSpecifics() -> Specifics<V, E>
    {
        if self is _DirectedGraph {
            return DirectedSpecifics<V, E>(parentGraph: self)
        } else if self is _UndirectedGraph {
            return UndirectedSpecifics<V, E>(parentGraph: self)
        } else {
            fatalError("Unspecialized graph instance in createSpecifics")
        }
    }
    
    public func getAllEdges(sourceVertex: V, targetVertex: V) -> Set<E>? {
        return specifics!.getAllEdges(sourceVertex, targetVertex: targetVertex)
    }
    
    public func getEdge(sourceVertex: V, targetVertex: V) -> E? {
        return specifics!.getEdge(sourceVertex, targetVertex: targetVertex)
    }
    
    public func getEdgeFactory() -> EdgeFactory<V, E>? {
        return edgeFactory
    }

    public func setEdgeSetFactory(edgeSetFactory: EdgeSetFactory<V, E>)
    {
        self.edgeSetFactory = edgeSetFactory
    }
    
    
    private func assertVertexExist(v: V) -> Bool {
        if containsVertex(v) {
            return true
        } else {
            assertionFailure("no such vertex in graph")
        }
        
        return false
    }
    
    public func addEdge(sourceVertex: V, targetVertex: V) -> E? {
        assertVertexExist(sourceVertex)
        assertVertexExist(targetVertex)
        
        if !allowingMultipleEdges &&
            containsEdge(sourceVertex, targetVertex: targetVertex)
        {
                return nil
        }
        
        if !allowingLoops && sourceVertex == targetVertex {
            assertionFailure(LOOPS_NOT_ALLOWED)
        }
        
        if let e = edgeFactory?.createEdge(sourceVertex, targetVertex: targetVertex) {
            if containsEdge(e) {
                return nil
            } else {
                let intrusiveEdge = createIntrusiveEdge(e, sourceVertex: sourceVertex, targetVertex: targetVertex)
                edgeMap[e] = intrusiveEdge
                // TODO: !!!
                //specifics.addEdgeToTouchingVertices(e)
                
                return e
            }
        }
        return nil
    }
    
    public func addEdge(sourceVertex: V, targetVertex: V, e: E) -> Bool {
        if containsEdge(e) {
            return false
        }
        
        if !allowingMultipleEdges &&
            containsEdge(sourceVertex, targetVertex: targetVertex)
        {
            return false
        }
        
        if !allowingLoops && sourceVertex == targetVertex {
            assertionFailure(LOOPS_NOT_ALLOWED)
        }
        
        let intrusiveEdge = createIntrusiveEdge(e, sourceVertex: sourceVertex, targetVertex: targetVertex)
        edgeMap[e] = intrusiveEdge
        // TODO: !!!
        //specifics.addEdgeToTouchingVertices(e)
        
        return true
    }
    
    private func createIntrusiveEdge(e: E,
        sourceVertex: V,
        targetVertex: V) -> IntrusiveEdge<V>
    {
        var intrusiveEdge: IntrusiveEdge<V>
        if e is IntrusiveEdge<V> {
            intrusiveEdge = e as! IntrusiveEdge<V>
        } else {
            intrusiveEdge = IntrusiveEdge<V>()
        }
        
        intrusiveEdge.source = sourceVertex
        intrusiveEdge.target = targetVertex
        return intrusiveEdge
    }
    
    public func addVertex(v: V) -> Bool {
        if containsVertex(v) {
            return false
        } else {
            specifics!.addVertex(v);
            return true
        }
    }
    
    public func containsEdge(sourceVertex: V, targetVertex: V) -> Bool {
        return getEdge(sourceVertex, targetVertex: targetVertex) != nil
    }
    
    public func containsEdge(e: E) -> Bool {
        return edgeMap.keys.contains(e)
    }
    
    public func containsVertex(v: V) -> Bool {
        return specifics!.getVertexSet().contains(v)
    }
    
    public func degreeOf(vertex: V) -> Int {
        return specifics!.degreeOf(vertex)
    }
    
    public func edgeSet() -> Set<E> {
        if unmodifiableEdgeSet == nil {
            unmodifiableEdgeSet = Set(edgeMap.keys)
        }
        
        return unmodifiableEdgeSet!
    }
    
    public func edgesOf(v: V) -> Set<E> {
        return specifics!.edgesOf(v)
    }
    
    public func incomingEdgesOf(vertex: V) -> Set<E> {
        return specifics!.incomingEdgesOf(vertex)
    }
    
    public func outDegreeOf(v: V) -> Int {
        return specifics!.outDegreeOf(v)
    }
    
    public func outgoingEdgesOf(vertex: V) -> Set<E> {
        return specifics!.outgoingEdgesOf(vertex)
    }
    
    
    /*
        AbstractGraph methods
    */
    public func removeAllEdges<T: CollectionType where T.Generator.Element == E>(edges: T) -> Bool {
        var modified = false
        
        for e in edges {
            modified = modified || removeEdge(e)
        }
        
        return modified
    }
    
    public func removeAllEdges(sourceVertex: V, targetVertex: V) -> Set<E>? {
        let removed = getAllEdges(sourceVertex, targetVertex: targetVertex)
        if removed == nil {
            return nil
        }
        removeAllEdges(removed!)
        
        return removed
    }
    
    public func removeAllVertices<T: CollectionType where T.Generator.Element == V>(vertices: T) -> Bool {
        var modified = false
        
        for v in vertices {
            modified = modified || removeVertex(v)
        }
        
        return modified
    }
    
    // TODO: finish implementation
    public func removeEdge(sourceVertex: V, targetVertex: V) -> E? {
        if let e = getEdge(sourceVertex, targetVertex: targetVertex) {
            specifics!.removeEdgeFromTouchingVertices(e)
            edgeMap.removeValueForKey(e)
            return e
        }
        
        return nil
    }
    
    public func removeEdge(e: E) -> Bool {
        if containsEdge(e) {
            specifics!.removeEdgeFromTouchingVertices(e)
            edgeMap.removeValueForKey(e)
            return true
        }
        
        return false
    }
    
    public func removeVertex(v: V) -> Bool {
        if containsVertex(v) {
            let touchingEdgesList = edgesOf(v)
            
            // cannot iterate over list - will cause
            // ConcurrentModificationException
            removeAllEdges(touchingEdgesList)
            
            specifics!.removeVertex(v) // remove the vertex itself
            
            return true;
        } else {
            return false;
        }
    }
    
    public func vertexSet() -> Set<V> {
        // TODO: make unmodifiable
        if unmodifiableVertexSet == nil {
            unmodifiableVertexSet = specifics!.getVertexSet()
        }
        
        return unmodifiableVertexSet!
    }
    
    public func getEdgeSource(e: E) -> V {
        return (e as! IntrusiveEdge).source!
    }
    
    public func getEdgeTarget(e: E) -> V {
        return (e as! IntrusiveEdge).target!
    }
    
    public func getEdgeWeight(e: E) -> Double {
        // TODO: finish implementation
        return 0
    }
    
    public func setEdgeWeight(e: E, weight: Double) {
        // TODO: finish implementation
        //assert (e instanceof DefaultWeightedEdge) : e.getClass();
        //((DefaultWeightedEdge) e).weight = weight;
    }
    
    
    public func crossComponentIteratorEdgesOf(v: V) -> Set<E> {
        abstractClassAssert()
    }
    
}

