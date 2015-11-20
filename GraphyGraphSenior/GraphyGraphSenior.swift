//
//  GraphyGraph.swift
//  GraphyGraphExample
//
//  Created by Peter Prokop on 15/11/15.
//  Copyright © 2015 Peter Prokop. All rights reserved.
//

import Foundation


//TODO: move each class to it's own file


public class IntrusiveEdge<V: Hashable>: Hashable {
    var source: V?
    var target: V?
    
    public var hashValue: Int { get { return 0 } }
}

public func ==<V: Hashable>(lhs: IntrusiveEdge<V>, rhs: IntrusiveEdge<V>) -> Bool {
    return lhs.source == rhs.source && lhs.target == rhs.target
}

public func ==<V: Hashable>(lhs: DefaultEdge<V>, rhs: DefaultEdge<V>) -> Bool {
    return lhs.source == rhs.source && lhs.target == rhs.target
}

public class DefaultEdge<V: Hashable>: IntrusiveEdge<V>, Initialisable {
    func getSource() -> V? {
        return source
    }
    func getTarget() -> V? {
        return target
    }
    
    public override required init() {
        
    }
}



class Specifics<V: Hashable, E: Hashable> {
    
    func addVertex(vertex: V) { abstractClassAssert() }
    
    func getVertexSet() -> Set<V> { abstractClassAssert(); return Set<V>() }
    
    func getAllEdges(sourceVertex: V, targetVertex: V) -> Set<E> { abstractClassAssert(); return Set<E>() }
    
    func getEdge(sourceVertex: V, targetVertex: V) -> E? { abstractClassAssert(); return nil }
    
    func addEdgeToTouchingVertices(e: E) { abstractClassAssert() }
    
    func degreeOf(vertex: V) -> Int { abstractClassAssert(); return 0}
    
    func edgesOf(vertex: V) -> Set<E> { abstractClassAssert(); return Set<E>() }
    
    func inDegreeOf(vertex: V) -> Int { abstractClassAssert(); return 0}
    
    func incomingEdgesOf(vertex: V) -> Set<E> { abstractClassAssert(); return Set<E>() }
    
    func outDegreeOf(vertex: V) -> Int { abstractClassAssert(); return 0}
    
    func outgoingEdgesOf(vertex: V) -> Set<E> { abstractClassAssert(); return Set<E>() }
    
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
    
    override func getVertexSet() -> Set<V> {
        return Set(vertexMapUndirected.keys)
    }
    
    override func getAllEdges(sourceVertex: V, targetVertex: V) -> Set<E> { abstractClassAssert(); return Set<E>() }
    
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

    // TODO: finish implementation
    
    override func addEdgeToTouchingVertices(e: E) { abstractClassAssert() }
    
    override func degreeOf(vertex: V) -> Int { abstractClassAssert(); return 0}
    
    override func edgesOf(vertex: V) -> Set<E> { abstractClassAssert(); return Set<E>() }
    
    override func inDegreeOf(vertex: V) -> Int { abstractClassAssert(); return 0}
    
    override func incomingEdgesOf(vertex: V) -> Set<E> { abstractClassAssert(); return Set<E>() }
    
    override func outDegreeOf(vertex: V) -> Int { abstractClassAssert(); return 0}
    
    override func outgoingEdgesOf(vertex: V) -> Set<E> { abstractClassAssert(); return Set<E>() }
    
    override func removeEdgeFromTouchingVertices(e: E) { abstractClassAssert() }
    
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
        // TODO: add directed specifics
        return UndirectedSpecifics<V, E>(parentGraph: self)
        /*
            if (this instanceof DirectedGraph<?, ?>) {
            return createDirectedSpecifics();
            } else if (this instanceof UndirectedGraph<?, ?>) {
            return createUndirectedSpecifics();
            } else {
            throw new IllegalArgumentException(
            "must be instance of either DirectedGraph or UndirectedGraph");
            }
        */
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
    
    public func edgeSet() -> Set<E> {
        if unmodifiableEdgeSet == nil {
            unmodifiableEdgeSet = Set(edgeMap.keys)
        }
        
        return unmodifiableEdgeSet!
    }
    
    public func edgesOf(v: V) -> Set<E> {
        return Set<E>()
    }
    
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
    
    public func removeEdge(sourceVertex: V, targetVertex: V) {
        
    }
    
    public func removeEdge(e: E) -> Bool {
        return false
    }
    
    public func removeVertex(v: V) -> Bool {
        return false
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
        return 0
    }
}

class DirectedEdgeContainer<VV: Hashable, EE: Hashable> {
    var incoming: Set<EE>?
    var outgoing: Set<EE>?
    private var unmodifiableIncoming: Set<EE>?
    private var unmodifiableOutgoing: Set<EE>?
}

public class ClassBasedEdgeFactory<V: Hashable, E: Hashable where E: Initialisable>: EdgeFactory<V, E> {
    override func createEdge(sourceVertex: V, targetVertex: V) -> E? {
        return E()
    }
}

public class SimpleGraph<V: Hashable, E: Hashable where E: Initialisable>: AbstractBaseGraph<V, E> {
    init(edgeFactory: EdgeFactory<V, E>) {
        super.init(edgeFactory: edgeFactory, allowMultipleEdges: false, allowLoops: false)
    }
    
    convenience override init() {
        self.init(edgeFactory: ClassBasedEdgeFactory<V,E>())
    }
}
