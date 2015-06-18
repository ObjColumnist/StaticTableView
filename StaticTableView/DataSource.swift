//
//  DataSource.swift
//  StaticTableView
//
//  Created by Spencer MacDonald on 28/04/2015.
//  Copyright (c) 2015 Square Bracket Software. All rights reserved.
//

import UIKit

public class DataSource {
    public var sections: [Section] = []
    public var tableView: UITableView?
    public var allowsEmptySections: Bool = false
        
    public var numberOfSections: Int {
        get {
            return count(sections)
        }
    }
    
    public var numberOfRows: Int {
        get {
            return sections.reduce(0, combine: {$0 + $1.numberOfRows})
        }
    }
    
    public var sectionIndexTitles: [String] {
        get {
            var sectionIndexTitles: [String] = []
            
            for section in sections {
                if let indexTitle = section.indexTitle {
                    sectionIndexTitles.append(indexTitle)
                }
            }
            
            return sectionIndexTitles
        }
    }
    
    public var selectedRows: [Row] {
        get {
            var selectedRows: [Row] = []
            
            if let selectedIndexPaths = tableView?.indexPathsForSelectedRows() as? [NSIndexPath] {
                for indexPath in selectedIndexPaths{
                    selectedRows.append(rowAtIndexPath(indexPath))
                }
            }
            
            return selectedRows
        }
    }
    
    public var empty: Bool {
        get {
            return (numberOfRows == 0)
        }
    }
    
    public subscript(index: Int) -> Section {
        get {
            return sections[index]
        }
        set(newValue) {
            sections[index] = newValue
        }
    }
    
    public subscript(indexPath: NSIndexPath) -> Row {
        get {
            return sections[indexPath.section].rows[indexPath.row]
        }
        set(newValue) {
            sections[indexPath.section].rows[indexPath.row] = newValue
        }
    }
    
    public init(){
        
    }
    
    public func sectionAtIndex(index: Int) -> Section {
        return sections[index]
    }
    
    public func rowAtIndexPath(indexPath: NSIndexPath) -> Row {
        return sections[indexPath.section].rows[indexPath.row]
    }
    
    public func cellAtIndexPath(indexPath: NSIndexPath) -> UITableViewCell? {
        return sections[indexPath.section].rows[indexPath.row].cell
    }
    
    public func objectAtIndexPath(indexPath: NSIndexPath) -> AnyObject? {
        return sections[indexPath.section].rows[indexPath.row].object
    }
        
    public func indexForSection(aSection: Section) -> Int? {
        var indexForSection: Int?
        
        for (sectionIndex, section) in enumerate(sections) {
            
            if aSection == section{
                indexForSection = sectionIndex
                break
            }
            else if let updatedSection = section as? UpdatedSection {
                if updatedSection.updateAction == .Insert{
                    if aSection == updatedSection.originalSection {
                        indexForSection = sectionIndex
                        break
                    }
                }
            }
        }
        
        return indexForSection
    }
    
    public func indexPathForRow(aRow: Row)-> NSIndexPath? {
    
        var indexPathForRow: NSIndexPath?
        
        for (sectionIndex, section) in enumerate(sections) {
            for (rowIndex, row) in enumerate(section.rows) {
                if aRow == row {
                    indexPathForRow = NSIndexPath(forRow: rowIndex, inSection: sectionIndex)
                    break
                }
                else if let updatedRow = row as? UpdatedRow {
                    if updatedRow.updateAction == .Insert{
                        if aRow == updatedRow.originalRow {
                            indexPathForRow = NSIndexPath(forRow: rowIndex, inSection: sectionIndex)
                            break
                        }
                    }
                }
            }
        }
    
        return indexPathForRow
    }
    
    public func indexPathForCell(cell: UITableViewCell)-> NSIndexPath? {
        
        var indexPathForCell: NSIndexPath?
        
        for (sectionIndex, section) in enumerate(sections) {
            for (rowIndex, row) in enumerate(section.rows) {
                if cell == row.cell {
                    indexPathForCell = NSIndexPath(forRow: rowIndex, inSection: sectionIndex)
                    break
                }
                else if let updatedRow = row as? UpdatedRow {
                    if updatedRow.updateAction == .Insert{
                        if cell == updatedRow.originalRow.cell {
                            indexPathForCell = NSIndexPath(forRow: rowIndex, inSection: sectionIndex)
                            break
                        }
                    }
                }
            }
        }
        
        return indexPathForCell
    }
    
    // MARK: Updates
    
    public func beginUpdates(){
        CATransaction.begin()
        tableView?.beginUpdates()
    }
    
    public func commitUpdates(){
        var sections = self.sections
        
        for (sectionIndex, section) in enumerate(sections) {
            var rows = section.rows
            
            for (rowIndex, row) in enumerate(section.rows) {
                if let row = row as? UpdatedRow {
                    if row.updateAction == .Insert {
                        let indexPath  = NSIndexPath(forRow: find(rows, row)!, inSection: sectionIndex)
                        let indexPaths = [indexPath]
                        self.tableView?.insertRowsAtIndexPaths(indexPaths, withRowAnimation:row.rowAnimation)
                        rows[find(rows, row)!] = row.originalRow
                    }
                    else if row.updateAction == .Delete {
                        let indexPath  = NSIndexPath(forRow: find(rows, row)!, inSection: sectionIndex)
                        let indexPaths = [indexPath]
                        self.tableView?.deleteRowsAtIndexPaths(indexPaths, withRowAnimation:row.rowAnimation)
                        rows.removeAtIndex(find(rows, row)!)
                    }
                }
            }
            section.rows = rows
        }
        
        for (sectionIndex, section) in enumerate(sections) {
            if let section = section as? UpdatedSection {
                if section.updateAction == .Insert {
                    self.tableView?.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: section.rowAnimation)
                    sections[sectionIndex] = section.originalSection
                }
                else if section.updateAction == .Delete {
                    self.tableView?.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: section.rowAnimation)
                    sections.removeAtIndex(sectionIndex)
                }
            }
        }
        
        self.sections = sections
    }
    
    public func endUpdatesWithCompletionHandler(completionHandler: (() -> (Void))?){
        CATransaction.setCompletionBlock { () -> Void in
            if let completionHandler = completionHandler {
                completionHandler()
            }
        }
        
        commitUpdates()
        
        self.tableView?.endUpdates()
        
        CATransaction.commit()
    }
    
    // MARK: Insert Sections
    
    public func insertSection(section: Section, atIndex index: Int, withRowAnimation rowAnimation:UITableViewRowAnimation = .Automatic) {
        let insertedSection = UpdatedSection(originalSection: section, index: index, updateAction: .Insert, rowAnimation: rowAnimation)
        sections.insert(insertedSection, atIndex: index)
    }
    
    public func insertSection(section: Section, beforeSection: Section, withRowAnimation rowAnimation:UITableViewRowAnimation = .Automatic) {
        if let index = indexForSection(beforeSection) {
            insertSection(section, atIndex: index, withRowAnimation: rowAnimation)
        }
    }
    
    public func insertSection(section: Section, afterSection: Section, withRowAnimation rowAnimation:UITableViewRowAnimation = .Automatic) {
        if let index = indexForSection(afterSection) {
            insertSection(section, atIndex: index + 1, withRowAnimation: rowAnimation)
        }
    }
    
    // MARK: Delete Sections
    
    public func deleteSectionAtIndex(index: Int, withRowAnimation rowAnimation: UITableViewRowAnimation = .Automatic){
        let section = sectionAtIndex(index)
        let deletedSection = UpdatedSection(originalSection: section, index: index, updateAction: .Insert, rowAnimation: rowAnimation)
        sections[index] = deletedSection
    }
    
    public func deleteSection(section: Section, withRowAnimation rowAnimation: UITableViewRowAnimation = .Automatic){
        if let index = indexForSection(section) {
            deleteSectionAtIndex(index, withRowAnimation: rowAnimation)
        }
    }
    
    // MARK: Insert Rows
    
    public func insertRow(row:Row, atIndexPath indexPath:NSIndexPath, withRowAnimation rowAnimation: UITableViewRowAnimation = .Automatic){
        let section = sectionAtIndex(indexPath.section)
        var rows = Array(section.rows)
        
        let insertedRow = UpdatedRow(originalRow: row, indexPath: indexPath, updateAction: .Insert, rowAnimation: rowAnimation)
    
        rows.insert(insertedRow, atIndex: indexPath.row)
        
        section.rows = rows
    }
    
    public func insertRow(row:Row, beforeRow: Row, withRowAnimation rowAnimation: UITableViewRowAnimation = .Automatic) {
        
        if let indexPath = indexPathForRow(row){
            insertRow(row, atIndexPath: indexPath, withRowAnimation: rowAnimation)
        }
    }
    
    public func insertRow(row:Row, afterRow: Row, withRowAnimation rowAnimation: UITableViewRowAnimation = .Automatic) {
        
        if let indexPath = indexPathForRow(afterRow){
            let afterIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
            insertRow(row, atIndexPath: afterIndexPath, withRowAnimation: rowAnimation)
        }
    }
    
    // MARK: Delete Rows
    
    public func deleteRowAtIndexPath(indexPath: NSIndexPath, withRowAnimation rowAnimation: UITableViewRowAnimation = .Automatic) {
        let section = sectionAtIndex(indexPath.section)
        var rows = Array(section.rows)
        let row = rows[indexPath.row]
        
        let deletedRow = UpdatedRow(originalRow: row, indexPath: indexPath, updateAction: .Delete, rowAnimation: rowAnimation)
        
        rows[indexPath.row] = deletedRow
        
        section.rows = rows
    }
    
    public func deleteRow(row: Row, withRowAnimation rowAnimation: UITableViewRowAnimation = .Automatic) {
        if let indexPath = indexPathForRow(row){
            deleteRowAtIndexPath(indexPath, withRowAnimation: rowAnimation)
        }
    }
}

private enum DataSourceUpdateAction {
    case Insert
    case Delete
}

private class UpdatedSection: Section {
    var originalSection: Section
    var index: Int
    var updateAction: DataSourceUpdateAction
    var rowAnimation: UITableViewRowAnimation
    
    init(originalSection: Section, index: Int, updateAction: DataSourceUpdateAction, rowAnimation: UITableViewRowAnimation) {
        self.originalSection = originalSection
        self.index = index
        self.updateAction = updateAction
        self.rowAnimation = rowAnimation
        super.init()
    }
}

private class UpdatedRow: Row {
    var originalRow: Row
    var indexPath: NSIndexPath
    var updateAction: DataSourceUpdateAction
    var rowAnimation: UITableViewRowAnimation
    
    init(originalRow: Row, indexPath: NSIndexPath, updateAction: DataSourceUpdateAction, rowAnimation: UITableViewRowAnimation) {
        self.originalRow = originalRow
        self.indexPath = indexPath
        self.updateAction = updateAction
        self.rowAnimation = rowAnimation
        super.init()
    }
}
