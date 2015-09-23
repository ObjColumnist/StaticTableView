//
//  Node.swift
//  StaticTableView
//
//  Created by Spencer MacDonald on 28/04/2015.
//  Copyright (c) 2015 Square Bracket Software. All rights reserved.
//

import UIKit

public class Node: Equatable, CustomStringConvertible {
    public var object: AnyObject?
    
    public init(){
        
    }
    
    public var description: String {
        get {
            return "\(self.dynamicType)"
        }
    }
}

public func ==(lhs: Node, rhs: Node) -> Bool {
    return lhs === rhs
}
