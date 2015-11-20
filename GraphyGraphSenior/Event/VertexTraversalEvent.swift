//
//  VertexTraversalEvent.swift
//  GraphyGraphExample
//
//  Created by Peter Prokop on 20/11/15.
//  Copyright © 2015 Peter Prokop. All rights reserved.
//

import Foundation

public class VertexTraversalEvent<V: Hashable>: EventObject {
    var vertex: V?
    
    init(eventSource: AnyObject, vertex: V?) {
        self.vertex = vertex
        super.init(source: eventSource)
    }
    
    func getVertex() -> V? {
        return vertex
    }
}