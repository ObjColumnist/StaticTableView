//
//  Node.swift
//  StaticTableView
//
//  Created by Spencer MacDonald on 28/04/2015.
//  Copyright (c) 2015 Square Bracket Software. All rights reserved.
//

import UIKit

open class Node: Equatable, CustomStringConvertible {
    open var object: AnyObject?
    
    public init() {
        
    }
    
    open var description: String {
        get {
            return "\(type(of: self))"
        }
    }
}

public func ==(lhs: Node, rhs: Node) -> Bool {
    return lhs === rhs
}
