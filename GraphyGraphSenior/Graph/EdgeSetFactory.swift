//
//  EdgeSetFactory.swift
//  GraphyGraphSeniorExample
//
//  Created by Peter Prokop on 20/11/15.
//  Copyright © 2015 Peter Prokop. All rights reserved.
//

import Foundation

public class EdgeSetFactory<V: Hashable, E: Hashable> {
    func createEdgeSet(v: V) -> Set<E> {
        abstractClassAssert()
        return Set<E>()
    }
}