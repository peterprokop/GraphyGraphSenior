//
//  EdgeFactory.swift
//  GraphyGraphSeniorExample
//
//  Created by Peter Prokop on 20/11/15.
//  Copyright © 2015 Peter Prokop. All rights reserved.
//

import Foundation

/**
 Was interface in original.
 Acts as abstract class.
 */
public class EdgeFactory<V: Hashable, E: Hashable> {
    func createEdge(sourceVertex: V, targetVertex: V) -> E? {
        abstractClassAssert()
        return nil
    }
}