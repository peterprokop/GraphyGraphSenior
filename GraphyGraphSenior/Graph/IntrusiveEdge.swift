//
//  IntrusiveEdge.swift
//  GraphyGraphSeniorExample
//
//  Created by Peter Prokop on 20/11/15.
//  Copyright © 2015 Peter Prokop. All rights reserved.
//

import Foundation

public func ==<V: Hashable>(lhs: IntrusiveEdge<V>, rhs: IntrusiveEdge<V>) -> Bool {
    return lhs.source == rhs.source && lhs.target == rhs.target
}

public class IntrusiveEdge<V: Hashable>: Hashable {
    var source: V?
    var target: V?
    
    public var hashValue: Int { get { return 0 } }
}
