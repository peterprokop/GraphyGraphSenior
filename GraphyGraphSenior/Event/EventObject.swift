//
//  EventObject.swift
//  GraphyGraphExample
//
//  Created by Peter Prokop on 20/11/15.
//  Copyright © 2015 Peter Prokop. All rights reserved.
//

import Foundation

public class EventObject {
    private var source: AnyObject
    
    init(source: AnyObject) {
        self.source = source
    }
    
    func getSource() -> AnyObject {
        return source
    }
    
    func toString() -> String {
        return String(self.dynamicType).componentsSeparatedByString(".").last! + "[source=\(source)]"
    }
}