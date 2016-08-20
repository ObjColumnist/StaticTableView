//
//  Section.swift
//  StaticTableView
//
//  Created by Spencer MacDonald on 28/04/2015.
//  Copyright (c) 2015 Square Bracket Software. All rights reserved.
//

import UIKit

open class Section: Node {
    open var rows: [Row] = []
    
    open var headerHeight: CGFloat?
    open var footerHeight: CGFloat?
    
    open var headerTitle: String?
    open var footerTitle: String?
    open var indexTitle: String?
    
    open var headerView: UIView?
    open var footerView: UIView?
    
    open var numberOfRows: Int {
        get {
           return rows.count
        }
    }
    
    open var isEmpty: Bool {
        get {
            return (numberOfRows == 0)
        }
    }
    
    open subscript(index: Int) -> Row {
        get {
            return rows[index]
        }
        set(newValue) {
            rows[index] = newValue
        }
    }
    
    public convenience init(rows: [Row]) {
        self.init()
        self.rows = rows
    }
    
    public convenience init(objects: [AnyObject]) {
        self.init()
        self.rows = objects.map({ Row(object: $0) })
    }
    
    public convenience init(cells: [UITableViewCell]) {
        self.init()
        self.rows = cells.map({ Row(cell: $0) })
    }
    
    open func add(_ row: Row) {
        rows.append(row)
    }
    
    open func add(_ cell: UITableViewCell) {
        rows.append(Row(cell: cell))
    }
    
    open func add(_ object: AnyObject) {
        rows.append(Row(object: object))
    }
    
    open func remove(_ row: Row) {
        if let index = index(for: row) {
            rows.remove(at: index)
        }
    }
    
    open func remove(_ cell: UITableViewCell) {
        if let index = index(for: cell) {
            rows.remove(at: index)
        }
    }
    
    open func remove(_ object: AnyObject) {
        if let index = index(for: object) {
            rows.remove(at: index)
        }
    }
    
    open func index(for row: Row) -> Int? {
        return rows.index(of: row)
    }
    
    open func index(for cell: UITableViewCell) -> Int? {
        for (index, row) in rows.enumerated() {
            if let rowCell = row.cell {
                if cell == rowCell {
                    return index
                }
            }
        }
        return nil
    }
    
    open func index(for object: AnyObject) -> Int? {
        for (index, _) in rows.enumerated() {
            if let object = object as? NSObject {
                for row in rows {
                    if let rowObject = row.object as? NSObject {
                        if object == rowObject {
                            return index
                        }
                    }
                }
            }
        }
        return nil
    }
    
    open func contains(_ row: Row) -> Bool {
        return rows.contains(row)
    }
    
    open func contains(_ cell: UITableViewCell) -> Bool {
        if let _ = index(for: cell) {
            return true
        } else {
            return false
        }
    }
    
    open func contains(_ object: AnyObject) -> Bool {
        if let _ = index(for: object) {
            return true
        } else {
            return false
        }
    }
    
    open override var description: String {
        get {
            return "\(type(of: self)) rows:\(rows)"
        }
    }
}
