//
//  Common.swift
//  GraphyGraphExample
//
//  Created by Peter Prokop on 20/11/15.
//  Copyright © 2015 Peter Prokop. All rights reserved.
//

import Foundation

func abstractClassAssert() {
    assertionFailure("This is abstract class. This method shouldn't be called.")
}

// Needed to be able to init generic types
public protocol Initialisable {
    init()
}