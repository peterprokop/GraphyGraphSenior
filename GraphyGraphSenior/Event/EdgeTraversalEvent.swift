//
//  EdgeTraversalEvent.swift
//  GraphyGraphExample
//
//  Created by Peter Prokop on 20/11/15.
//  Copyright © 2015 Peter Prokop. All rights reserved.
//

import Foundation

public class EdgeTraversalEvent<V: Hashable, E: Hashable>: EventObject {
    private var edge: E
    
    init(eventSource: AnyObject, edge: E) {
        self.edge = edge
        super.init(source: eventSource)        
    }
    
    public func getEdge() -> E {
        return edge
    }
}