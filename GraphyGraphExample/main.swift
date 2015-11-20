//
//  main.swift
//  GraphyGraphExample
//
//  Created by Peter Prokop on 15/11/15.
//  Copyright © 2015 Peter Prokop. All rights reserved.
//

import Foundation

// Have some troubles with generics in test module, so there are some tests in "main"


func simpleGraphTest() {
    let g = SimpleGraph<String, DefaultEdge<String>>()

    let v1 = "v1"
    let v2 = "v2"
    let v3 = "v3"
    let v4 = "v4"

    // add the vertices
    g.addVertex(v1);
    g.addVertex(v2);
    g.addVertex(v3);
    g.addVertex(v4);

    // add edges to create a circuit
    g.addEdge(v1, targetVertex: v2);
    print(g.edgeSet())
    g.addEdge(v2, targetVertex: v3);
    print(g.edgeSet())
    g.addEdge(v3, targetVertex: v4);
    print(g.edgeSet())
    g.addEdge(v4, targetVertex: v1);
    print(g.edgeSet())
    
    /*
    Should be in AsUndirectedGraphTest
    */
    typealias EdgeTA = DefaultEdge<String>
    
    var loop: EdgeTA?
    let directed = DefaultDirectedGraph<String, EdgeTA>()    
    
    directed.addVertex(v1);
    directed.addVertex(v2);
    directed.addVertex(v3);
    directed.addVertex(v4);
    directed.addEdge(v1, targetVertex: v2);
    directed.addEdge(v2, targetVertex: v3);
    directed.addEdge(v2, targetVertex: v4);
    loop = directed.addEdge(v4, targetVertex: v4);
}

simpleGraphTest()



/*
    DefaultDirectedGraphTest
*/
// In original DirectedMultigraph was used instead of DefaultDirectedGraph
func DefaultDirectedGraphTest() {
    let v1 = "v1"
    let v2 = "v2"
    let v3 = "v3"

    func testEdgeSetFactory()
    {
        let g = DefaultDirectedGraph<String, DefaultEdge<String>>()
        g.setEdgeSetFactory(ArrayListFactory<String, DefaultEdge<String>>())
        initMultiTriangle(g)
    }
    
    func testVertexOrderDeterminism()
    {
        let g = createMultiTriangle()
        
        // In original test order of vertexes was tested, but we can't do that in Swift
        /*
        Iterator<String> iter = g.vertexSet().iterator();
        assertEquals(v1, iter.next());
        assertEquals(v2, iter.next());
        assertEquals(v3, iter.next());
        */
        assert(g.vertexSet().contains(v1))
        assert(g.vertexSet().contains(v2))
        assert(g.vertexSet().contains(v3))
    }
    
    func createMultiTriangle() -> DefaultDirectedGraph<String, DefaultEdge<String>>
    {
        let g = DefaultDirectedGraph<String, DefaultEdge<String>>()
        initMultiTriangle(g)
        return g
    }
    
    func initMultiTriangle(g: DefaultDirectedGraph<String, DefaultEdge<String>>)
    {
        g.addVertex(v1);
        g.addVertex(v2);
        g.addVertex(v3);
        
        g.addEdge(v1, targetVertex: v2);
        g.addEdge(v2, targetVertex: v1);
        g.addEdge(v2, targetVertex: v3);
        g.addEdge(v3, targetVertex: v1);
    }
    
    testVertexOrderDeterminism()
}
DefaultDirectedGraphTest()