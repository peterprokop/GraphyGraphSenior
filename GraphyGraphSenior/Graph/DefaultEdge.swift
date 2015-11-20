//
//  DefaultEdge.swift
//  GraphyGraphSeniorExample
//
//  Created by Peter Prokop on 20/11/15.
//  Copyright © 2015 Peter Prokop. All rights reserved.
//

import Foundation

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
