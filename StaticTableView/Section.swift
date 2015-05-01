//
//  Section.swift
//  StaticTableView
//
//  Created by Spencer MacDonald on 28/04/2015.
//  Copyright (c) 2015 Square Bracket Software. All rights reserved.
//

import UIKit

public class Section: Node {
    public var rows: [Row] = []
    
    public var headerTitle: String?
    public var footerTitle: String?
    public var indexTitle: String?
    
    public var numberOfRows: Int {
        get {
           return count(rows)
        }
    }
    
    public subscript(index: Int) -> Row {
        get {
            return rows[index]
        }
        set(newValue) {
            rows[index] = newValue
        }
    }
    
    public convenience init(rows: [Row]){
        self.init()
        self.rows = rows
    }
    
    public convenience init(objects: [AnyObject]){
        self.init()
        self.rows = objects.map({ Row(object: $0) })
    }
    
    public convenience init(cells: [UITableViewCell]){
        self.init()
        self.rows = cells.map({ Row(cell: $0) })
    }
    
    public func addRow(row: Row){
        rows.append(row)
    }
    
    public func addCell(cell: UITableViewCell){
        rows.append(Row(cell: cell))
    }
    
    public func addObject(object: AnyObject){
        rows.append(Row(object: object))
    }
    
    public func removeRow(row: Row){
        if let index = indexForRow(row){
            rows.removeAtIndex(index)
        }
    }
    
    public func removeCell(cell: UITableViewCell){
        if let index = indexForCell(cell){
            rows.removeAtIndex(index)
        }
    }
    
    public func removeObject(object: AnyObject){
        if let index = indexForObject(object){
            rows.removeAtIndex(index)
        }
    }
    
    public func indexForRow(row: Row) -> Int?{
        return find(rows, row)
    }
    
    public func indexForCell(cell: UITableViewCell) -> Int?{
        for (index, row) in enumerate(rows){
            if let rowCell = row.cell {
                if cell == rowCell {
                    return index
                }
            }
        }
        return nil
    }
    
    public func indexForObject(object: AnyObject) -> Int?{
        for (index, row) in enumerate(rows){
            if let object = object as? NSObject {
                for row in rows{
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
    
    public func containsRow(row: Row) -> Bool{
        return contains(rows, row)
    }
    
    public func containsCell(cell: UITableViewCell) -> Bool{
        if let index = indexForCell(cell) {
            return true
        }
        else {
            return false
        }
    }
    
    public func containsObject(object: AnyObject) -> Bool{
        if let index = indexForObject(object) {
            return true
        }
        else {
            return false
        }
    }
}
