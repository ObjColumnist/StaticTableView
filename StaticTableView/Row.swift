//
//  Row.swift
//  StaticTableView
//
//  Created by Spencer MacDonald on 28/04/2015.
//  Copyright (c) 2015 Square Bracket Software. All rights reserved.
//

import UIKit

public class Row: Node {
    public var cell: UITableViewCell?
    
    public var height: CGFloat?
    public var estimatedHeight: CGFloat?

    public var editActions: [UITableViewRowAction]?
    
    public var didSelectHandler: ((Row, UITableView, NSIndexPath) -> Void)?
    public var didDeselectHandler: ((Row, UITableView, NSIndexPath) -> Void)?
    
    public var didTapAccessoryButtonHandler: ((Row, UITableView, NSIndexPath) -> Void)?
    
    public var editActionsHandler: ((Row, UITableView, NSIndexPath) -> [UITableViewRowAction]?)?
    
    public var dequeueCellHandler: ((Row, UITableView, NSIndexPath) -> UITableViewCell)?
    
    public convenience init(object: AnyObject?){
        self.init()
        self.object = object
    }
    
    public convenience init(cell: UITableViewCell){
        self.init()
        self.cell = cell
    }
}

public func ==(lhs: Row, rhs: Row) -> Bool {
    if let lhsCell = lhs.cell, rhsCell = rhs.cell where lhsCell == rhsCell {
        return true
    } else {
        return lhs === rhs   
    }
}
