//
//  ConnectedComponentTraversalEvent.swift
//  GraphyGraphExample
//
//  Created by Peter Prokop on 20/11/15.
//  Copyright © 2015 Peter Prokop. All rights reserved.
//

import Foundation

/**
 A traversal event with respect to a connected component.
*/
public class ConnectedComponentTraversalEvent: EventObject {
    /**
    * Connected component traversal started event.
    */
    static let CONNECTED_COMPONENT_STARTED = 31
    
    /**
    * Connected component traversal finished event.
    */
    static let CONNECTED_COMPONENT_FINISHED = 32
    
    var type: Int
    
    init(eventSource: AnyObject, type: Int) {
        self.type = type
        
        super.init(source: eventSource)        
    }
    
    /**
        Returns the event type.
    
        - return: the event type.
    */
    public func getType() -> Int {
        return type
    }
}