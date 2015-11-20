//
//  CrossComponentIterator.swift
//  GraphyGraphExample
//
//  Created by Peter Prokop on 20/11/15.
//  Copyright © 2015 Peter Prokop. All rights reserved.
//

import Foundation

enum CrossComponentIteratorVisitColor
{
    ///Vertex has not been returned via iterator yet.
    case WHITE,
    
    ///Vertex has been returned via iterator, but we're not done with all of its out-edges yet.
    GRAY,
    
    ///Vertex has been returned via iterator, and we're done with all of its out-edges.
    BLACK
}

/**
 Provides a cross-connected-component traversal functionality for iterator
 subclasses.
 
 Abstract class.
*/
public class CrossComponentIterator<V: Hashable, E: Hashable, D, G: Graph>: AbstractGraphIterator<V, E> {
    
    
    private let CCS_BEFORE_COMPONENT = 1
    private let CCS_WITHIN_COMPONENT = 2
    private let CCS_AFTER_COMPONENT = 3
    
    /**
        Creates a new iterator for the specified graph. Iteration will start at
        the specified start vertex. If the specified start vertex is <code>
        null</code>, Iteration will start at an arbitrary graph vertex.
     
        - param g: the graph to be iterated.
        - param startVertex: the vertex iteration to be started.
    */
    public init(graph: G, startVertex: V?)
    {
        super.init()

        /*
        self.graph = graph

        specifics = createGraphSpecifics(g);
        vertexIterator = g.vertexSet().iterator();
        setCrossComponentTraversal(startVertex == null);

        reusableEdgeEvent = new FlyweightEdgeEvent<V, E>(this, null);
        reusableVertexEvent = new FlyweightVertexEvent<V>(this, null);

        if (startVertex == null) {
            // pick a start vertex if graph not empty
            if (vertexIterator.hasNext()) {
                this.startVertex = vertexIterator.next();
            } else {
                this.startVertex = null;
            }
        } else if (g.containsVertex(startVertex)) {
            this.startVertex = startVertex;
        } else {
            throw new IllegalArgumentException(
                "graph must contain the start vertex");
        }
        */
    }
    
    // TODO: finish implementation
}