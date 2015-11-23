//
//  CrossComponentIterator.swift
//  GraphyGraphExample
//
//  Created by Peter Prokop on 20/11/15.
//  Copyright © 2015 Peter Prokop. All rights reserved.
//

import Foundation

class FlyweightEdgeEvent<V: Hashable, E: Hashable>: EdgeTraversalEvent<V, E> {
    /**
    @see EdgeTraversalEvent#EdgeTraversalEvent(Object, Edge)
    */
    override init(eventSource: AnyObject, edge: E?) {
        super.init(eventSource: eventSource, edge: edge)
    }
    
    /**
    * Sets the edge of this event.
    *
    * @param edge the edge to be set.
    */
    private func setEdge(edge: E?) {
        self.edge = edge;
    }
}

 class FlyweightVertexEvent<V: Hashable>: VertexTraversalEvent<V> {
    /**
    * @see VertexTraversalEvent#VertexTraversalEvent(Object, Object)
    */
    override init(eventSource: AnyObject, vertex: V?) {
        super.init(eventSource: eventSource, vertex: vertex)
    }
    
    /**
    * Sets the vertex of this event.
    *
    * @param vertex the vertex to be set.
    */
    private func setVertex(vertex: V?) {
        self.vertex = vertex
    }
}

// TODO: since we have crossComponentIteratorEdgesOf we don't need specifics at all

/**
 Provides unified interface for operations that are different in directed
 graphs and in undirected graphs.
 
 Abstract class.
*/
//class CrossComponentIteratorSpecifics<V: Hashable, E: Hashable> {
private class CrossComponentIteratorSpecifics<V: Hashable, E: Hashable, DG: Graph where DG.V == V, DG.E == E>
{
    private var graph: DG
    
    /**
     * Creates a new DirectedSpecifics object.
     *
     * @param g the graph for which this specifics object to be created.
     */
    private init(graph: DG) {
        self.graph = graph
    }
    
    /**
     Returns the edges outgoing from the specified vertex in case of
     directed graph, and the edge touching the specified vertex in case of
     undirected graph.
    
     - parameter: vertex the vertex whose outgoing edges are to be returned.
    
     - return: the edges outgoing from the specified vertex in case of
     directed graph, and the edge touching the specified vertex in case of
     undirected graph.
    */
    func edgesOf(vertex: V) -> Set<E> {
        //abstractClassAssert()
        return graph.crossComponentIteratorEdgesOf(vertex)
    }
}

/*
/**
 * An implementation of {@link Specifics} for a directed graph.
 */
private class DirectedSpecifics<V: Hashable, E: Hashable, DG: Graph where DG.V == V, DG.E == E>
    : CrossComponentIteratorSpecifics<V, E>
{
    private var graph: DG
    
    /**
    * Creates a new DirectedSpecifics object.
    *
    * @param g the graph for which this specifics object to be created.
    */
    private init(graph: DG) {
        self.graph = graph
    }
    
    /**
     @see CrossComponentIterator.Specifics#edgesOf(Object)
    */
    override func edgesOf(vertex: V) -> Set<E> {
        return graph.crossComponentIteratorEdgesOf(vertex)
    }
}

/**
 * An implementation of {@link Specifics} in which edge direction (if any)
 * is ignored.
 */
private class UndirectedSpecifics<VV: Hashable, EE: Hashable, UG: Graph where UG.V == VV, UG.E == EE>
    : CrossComponentIteratorSpecifics<VV, EE>
{
    private var graph: UG
    
    /**
    * Creates a new UndirectedSpecifics object.
    *
    * @param g the graph for which this specifics object to be created.
    */
    init(graph: UG) {
        self.graph = graph
    }
    
    /**
    * @see CrossComponentIterator.Specifics#edgesOf(Object)
    */
    override func edgesOf(vertex: VV) -> Set<EE>
    {
        return graph.crossComponentIteratorEdgesOf(vertex)
    }
}
*/

enum CrossComponentIteratorVisitColor
{
    ///Vertex has not been returned via iterator yet.
    case WHITE,
    
    ///Vertex has been returned via iterator, but we're not done with all of its out-edges yet.
    GRAY,
    
    ///Vertex has been returned via iterator, and we're done with all of its out-edges.
    BLACK
}

let CCS_BEFORE_COMPONENT = 1
let CCS_WITHIN_COMPONENT = 2
let CCS_AFTER_COMPONENT = 3

/**
 Provides a cross-connected-component traversal functionality for iterator
 subclasses.
 
 Abstract class.
*/
public class CrossComponentIterator<V: Hashable, E: Hashable, D, G: Graph where G.V == V, G.E == E>
    : AbstractGraphIterator<V, E>
{

    private var ccFinishedEvent: ConnectedComponentTraversalEvent?
    private var ccStartedEvent: ConnectedComponentTraversalEvent?

    // TODO(original): support ConcurrentModificationException if graph modified during iteration.
    private var reusableEdgeEvent: FlyweightEdgeEvent<V, E>?
    private var reusableVertexEvent: FlyweightVertexEvent<V>?
    private var vertexIterator: BaseIterator<V>

    
    /**
     * Stores the vertices that have been seen during iteration and (optionally)
     * some additional traversal info regarding each vertex.
     */
    private var seen = Dictionary<V, D>()
    private var startVertex: V?
    private var specifics: CrossComponentIteratorSpecifics<V, E, G>?

    var graph: G

    /**
     * The connected component state
     */
    private var state = CCS_BEFORE_COMPONENT

    
    /**
        Creates a new iterator for the specified graph. Iteration will start at
        the specified start vertex. If the specified start vertex is <code>
        null</code>, Iteration will start at an arbitrary graph vertex.
     
        - param g: the graph to be iterated.
        - param startVertex: the vertex iteration to be started.
    */
    public init(graph: G, startVertex: V?)
    {
        self.graph = graph
        vertexIterator = GeneratorBasedIterator(generator: graph.vertexSet().generate())
        
        if startVertex == nil {
            // pick a start vertex if graph not empty
            if vertexIterator.hasNext() {
                self.startVertex = vertexIterator.next();
            } else {
                self.startVertex = nil
            }
        } else if graph.containsVertex(startVertex!) {
            self.startVertex = startVertex
        } else {
            assertionFailure("graph must contain the start vertex")
        }
        
        super.init()

        specifics = CrossComponentIteratorSpecifics<V, E, G>(graph: graph)
        
        setCrossComponentTraversal(startVertex == nil)
        
        ccFinishedEvent = ConnectedComponentTraversalEvent(eventSource: self,
            type: ConnectedComponentTraversalEvent.CONNECTED_COMPONENT_FINISHED)
        ccStartedEvent = ConnectedComponentTraversalEvent(eventSource: self,
            type: ConnectedComponentTraversalEvent.CONNECTED_COMPONENT_STARTED)

        reusableEdgeEvent = FlyweightEdgeEvent<V, E>(eventSource: self, edge: nil)
        reusableVertexEvent = FlyweightVertexEvent<V>(eventSource: self, vertex: nil)

    }
    
    public func getGraph() -> G {
        return graph;
    }
    
    public override func hasNext() -> Bool
    {
        if startVertex != nil {
            encounterStartVertex()
        }

        if isConnectedComponentExhausted() {
            if state == CCS_WITHIN_COMPONENT {
                state = CCS_AFTER_COMPONENT
                if nListeners != 0 {
                    fireConnectedComponentFinished(ccFinishedEvent!);
                }
            }

            if isCrossComponentTraversal() {
                while (vertexIterator.hasNext()) {
                    let v = vertexIterator.next()

                    if !isSeenVertex(v!) {
                        encounterVertex(v!, edge: nil)
                        state = CCS_BEFORE_COMPONENT;

                        return true
                    }
                }

                return false
            } else {
                return false
            }
        } else {
            return true
            
        }
    }
    
    public override func next() -> V
    {
        if startVertex != nil {
            encounterStartVertex()
        }

        if hasNext() {
            if state == CCS_BEFORE_COMPONENT {
                state = CCS_WITHIN_COMPONENT
                if nListeners != 0 {
                    fireConnectedComponentStarted(ccStartedEvent!)
                }
            }

            let nextVertex = provideNextVertex()
            if nListeners != 0 {
                fireVertexTraversed(createVertexTraversalEvent(nextVertex))
            }

            addUnseenChildrenOf(nextVertex);

            return nextVertex
        } else {
            fatalError("next() called but there is no next element")
        }
    }
    
     /**
     * Returns <tt>true</tt> if there are no more uniterated vertices in the
     * currently iterated connected component; <tt>false</tt> otherwise.
     *
     * @return <tt>true</tt> if there are no more uniterated vertices in the
     * currently iterated connected component; <tt>false</tt> otherwise.
     */
    func isConnectedComponentExhausted() -> Bool {
        abstractClassAssert()
    }

    /**
     * Update data structures the first time we see a vertex.
     *
     * @param vertex the vertex encountered
     * @param edge the edge via which the vertex was encountered, or null if the
     * vertex is a starting point
     */
    func encounterVertex(vertex: V, edge: E?) {
        abstractClassAssert()
    }

    /**
     * Returns the vertex to be returned in the following call to the iterator
     * <code>next</code> method.
     *
     * @return the next vertex to be returned by this iterator.
     */
    func provideNextVertex() -> V {
        abstractClassAssert()
    }

    /**
     * Access the data stored for a seen vertex.
     *
     * @param vertex a vertex which has already been seen.
     *
     * @return data associated with the seen vertex or <code>null</code> if no
     * data was associated with the vertex. A <code>null</code> return can also
     * indicate that the vertex was explicitly associated with <code>
     * null</code>.
     */
    func getSeenData(vertex: V) -> D? {
        return seen[vertex]
    }

    /**
     * Determines whether a vertex has been seen yet by this traversal.
     *
     * @param vertex vertex in question
     *
     * @return <tt>true</tt> if vertex has already been seen
     */
    func isSeenVertex(vertex: V) -> Bool
    {
        return seen.keys.contains(vertex)
    }

    /**
     * Called whenever we re-encounter a vertex. The default implementation does
     * nothing.
     *
     * @param vertex the vertex re-encountered
     * @param edge the edge via which the vertex was re-encountered
     */
    func encounterVertexAgain(vertex: V, edge: E?) throws {
        abstractClassAssert()
    }

    /**
     * Stores iterator-dependent data for a vertex that has been seen.
     *
     * @param vertex a vertex which has been seen.
     * @param data data to be associated with the seen vertex.
     *
     * @return previous value associated with specified vertex or <code>
     * null</code> if no data was associated with the vertex. A <code>
     * null</code> return can also indicate that the vertex was explicitly
     * associated with <code>null</code>.
     */
    func putSeenData(vertex: V, data: D) -> D? {
        return seen.updateValue(data, forKey: vertex)
    }

    /**
     * Called when a vertex has been finished (meaning is dependent on traversal
     * represented by subclass).
     *
     * @param vertex vertex which has been finished
     */
    func finishVertex(vertex: V) {
        if nListeners != 0 {
            fireVertexFinished(createVertexTraversalEvent(vertex));
        }
    }

    private func addUnseenChildrenOf(vertex: V) {
        for edge in specifics!.edgesOf(vertex) {
            if nListeners != 0 {
                fireEdgeTraversed(createEdgeTraversalEvent(edge));
            }

            let oppositeV = Graphs.getOppositeVertex(graph, edge: edge, vertex: vertex)

            if isSeenVertex(oppositeV) {
                try! encounterVertexAgain(oppositeV, edge: edge);
            } else {
                encounterVertex(oppositeV, edge: edge);
            }
        }
    }

    private func createEdgeTraversalEvent(edge: E) -> EdgeTraversalEvent<V, E> {
        if isReuseEvents() {
            reusableEdgeEvent!.setEdge(edge)

            return reusableEdgeEvent!
        } else {
            return EdgeTraversalEvent<V, E>(eventSource: self, edge: edge)
        }
    }

    private func createVertexTraversalEvent(vertex: V) -> VertexTraversalEvent<V> {
        if isReuseEvents() {
            reusableVertexEvent!.setVertex(vertex)

            return reusableVertexEvent!
        } else {
            return VertexTraversalEvent<V>(eventSource: self, vertex: vertex)
        }
    }

    private func encounterStartVertex() {
        encounterVertex(startVertex!, edge: nil)
        startVertex = nil
    }
}