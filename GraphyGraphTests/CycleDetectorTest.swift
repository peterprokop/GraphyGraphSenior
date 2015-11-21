//
//  CycleDetectorTest.swift
//  GraphyGraphSeniorExample
//
//  Created by Peter Prokop on 20/11/15.
//  Copyright © 2015 Peter Prokop. All rights reserved.
//

import XCTest
import GraphyGraphSeniorExample

/*
class CycleDetectorTest: XCTestCase {
    
    let V1 = "v1"
    let V2 = "v2"
    let V3 = "v3"
    let V4 = "v4"
    let V5 = "v5"
    let V6 = "v6"
    let V7 = "v7"

    func createGraph<G: Graph where G.V == String, G.E == DefaultEdge<String>>(g: G) {
        g.addVertex(V1)
        g.addVertex(V2)
        g.addVertex(V3)
        g.addVertex(V4)
        g.addVertex(V5)
        g.addVertex(V6)
        g.addVertex(V7)

        g.addEdge(V1, targetVertex: V2)
        g.addEdge(V2, targetVertex: V3)
        g.addEdge(V3, targetVertex: V4)
        g.addEdge(V4, targetVertex: V1)
        g.addEdge(V4, targetVertex: V5)
        g.addEdge(V5, targetVertex: V6)
        g.addEdge(V1, targetVertex: V6)

        // test an edge which leads into a cycle, but where the source
        // is not itself part of a cycle
        g.addEdge(V7, targetVertex: V1)
    }

    func testDirectedWithCycle()
    {
        let g = DefaultDirectedGraph<String, DefaultEdge<String>>()
        createGraph(g)

        var cyclicSet = Set<String>()
        cyclicSet.insert(V1)
        cyclicSet.insert(V2)
        cyclicSet.insert(V3)
        cyclicSet.insert(V4)

        var acyclicSet = Set<String>()
        acyclicSet.insert(V5)
        acyclicSet.insert(V6)
        acyclicSet.insert(V7)

        runTest(g, cyclicSet: cyclicSet, acyclicSet: acyclicSet)
    }
    
    func testDirectedWithoutCycle() {
        let g = DefaultDirectedGraph<String, DefaultEdge<String>>()
        createGraph(g)
        g.removeVertex(V2);

        let cyclicSet = Set<String>()
        let acyclicSet = g.vertexSet()
        
        runTest(g, cyclicSet: cyclicSet, acyclicSet: acyclicSet)
    }

    func runTest<G: DirectedGraph where G.V == String, G.E == DefaultEdge<String>>
        (g: G,
        cyclicSet: Set<String>,
        acyclicSet: Set<String>)
    {
        let detector = CycleDetector<String, DefaultEdge<String>, G>(graph: g)

        let emptySet = Set<String>()

        XCTAssertEqual(!cyclicSet.isEmpty, detector.detectCycles());
        // TODO: finish
        //XCTAssertEqual(cyclicSet, detector.findCycles());

        for v in cyclicSet {
            XCTAssertEqual(true, detector.detectCyclesContainingVertex(v));
            //XCTAssertEqual(cyclicSet, detector.findCyclesContainingVertex(v));
        }

        for v in acyclicSet {
            XCTAssertEqual(false, detector.detectCyclesContainingVertex(v));
            //XCTAssertEqual(emptySet, detector.findCyclesContainingVertex(v));
        }
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
*/