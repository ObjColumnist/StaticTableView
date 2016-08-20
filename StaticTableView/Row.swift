//
//  Row.swift
//  StaticTableView
//
//  Created by Spencer MacDonald on 28/04/2015.
//  Copyright (c) 2015 Square Bracket Software. All rights reserved.
//

import UIKit

open class Row: Node {
    open var cell: UITableViewCell?
    
    open var height: CGFloat?
    open var estimatedHeight: CGFloat?

    open var editActions: [UITableViewRowAction]?
    
    open var didSelectHandler: ((Row, UITableView, IndexPath) -> Void)?
    open var didDeselectHandler: ((Row, UITableView, IndexPath) -> Void)?
    
    open var didTapAccessoryButtonHandler: ((Row, UITableView, IndexPath) -> Void)?
    
    open var heightHandler: ((Row, UITableView, IndexPath) -> CGFloat)?

    open var editActionsHandler: ((Row, UITableView, IndexPath) -> [UITableViewRowAction]?)?
    
    open var dequeueCellHandler: ((Row, UITableView, IndexPath) -> UITableViewCell)?
    
    public convenience init(object: AnyObject?) {
        self.init()
        self.object = object
    }
    
    public convenience init(cell: UITableViewCell) {
        self.init()
        self.cell = cell
    }
}

public func ==(lhs: Row, rhs: Row) -> Bool {
    if let lhsCell = lhs.cell, let rhsCell = rhs.cell , lhsCell == rhsCell {
        return true
    } else {
        return lhs === rhs   
    }
}
