//
//  Node.swift
//  StaticTableView
//
//  Created by Spencer MacDonald on 28/04/2015.
//  Copyright (c) 2015 Square Bracket Software. All rights reserved.
//

import UIKit

public class Node: Equatable {
    public var object: AnyObject?
    
    public init(){
        
    }
}

public func ==(lhs: Node, rhs: Node) -> Bool {
    return true
}
