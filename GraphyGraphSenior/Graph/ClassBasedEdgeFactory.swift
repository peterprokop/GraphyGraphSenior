//
//  ClassBasedEdgeFactory.swift
//  GraphyGraphSeniorExample
//
//  Created by Peter Prokop on 20/11/15.
//  Copyright © 2015 Peter Prokop. All rights reserved.
//

import Foundation

public class ClassBasedEdgeFactory<V: Hashable, E: Hashable where E: Initialisable>: EdgeFactory<V, E> {
    override func createEdge(sourceVertex: V, targetVertex: V) -> E? {
        return E()
    }
}