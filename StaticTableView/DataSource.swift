//
//  DataSource.swift
//  StaticTableView
//
//  Created by Spencer MacDonald on 28/04/2015.
//  Copyright (c) 2015 Square Bracket Software. All rights reserved.
//

import UIKit

open class DataSource {
    open var sections: [Section] = []
    open var tableView: UITableView?
    open var allowsEmptySections: Bool = false
        
    open var numberOfSections: Int {
        get {
            return sections.count
        }
    }
    
    open var numberOfRows: Int {
        get {
            return sections.reduce(0, {$0 + $1.numberOfRows})
        }
    }
    
    open var sectionIndexTitles: [String] {
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
    
    open var selectedRows: [Row] {
        get {
            var selectedRows: [Row] = []
            
            if let selectedIndexPaths = tableView?.indexPathsForSelectedRows {
                for indexPath in selectedIndexPaths {
                    selectedRows.append(row(at: indexPath))
                }
            }
            
            return selectedRows
        }
    }
    
    open var isEmpty: Bool {
        get {
            return (numberOfRows == 0)
        }
    }
    
    open subscript(index: Int) -> Section {
        get {
            return sections[index]
        }
        set(newValue) {
            sections[index] = newValue
        }
    }
    
    open subscript(indexPath: IndexPath) -> Row {
        get {
            return sections[(indexPath as NSIndexPath).section].rows[(indexPath as NSIndexPath).row]
        }
        set(newValue) {
            sections[(indexPath as NSIndexPath).section].rows[(indexPath as NSIndexPath).row] = newValue
        }
    }
    
    public init() {
        
    }
    
    open func section(at index: Int) -> Section {
        return sections[index]
    }
    
    open func row(at indexPath: IndexPath) -> Row {
        return sections[(indexPath as NSIndexPath).section].rows[(indexPath as NSIndexPath).row]
    }
    
    open func cell(at indexPath: IndexPath) -> UITableViewCell? {
        return sections[(indexPath as NSIndexPath).section].rows[(indexPath as NSIndexPath).row].cell
    }
    
    open func object(at indexPath: IndexPath) -> AnyObject? {
        return sections[(indexPath as NSIndexPath).section].rows[(indexPath as NSIndexPath).row].object
    }
        
    open func index(for aSection: Section) -> Int? {
        var indexForSection: Int?
        
        for (sectionIndex, section) in sections.enumerated() {
            
            if aSection == section{
                indexForSection = sectionIndex
                break
            } else if let updatedSection = section as? UpdatedSection {
                if updatedSection.updateAction == .insert{
                    if aSection == updatedSection.originalSection {
                        indexForSection = sectionIndex
                        break
                    }
                }
            }
        }
        
        return indexForSection
    }
    
    open func indexPath(for aRow: Row) -> IndexPath? {
    
        var indexPathForRow: IndexPath?
        
        for (sectionIndex, section) in sections.enumerated() {
            for (rowIndex, row) in section.rows.enumerated() {
                if aRow == row {
                    indexPathForRow = IndexPath(row: rowIndex, section: sectionIndex)
                    break
                } else if let updatedRow = row as? UpdatedRow {
                    if updatedRow.updateAction == .insert{
                        if aRow == updatedRow.originalRow {
                            indexPathForRow = IndexPath(row: rowIndex, section: sectionIndex)
                            break
                        }
                    }
                }
            }
        }
    
        return indexPathForRow
    }
    
    open func indexPath(for cell: UITableViewCell) -> IndexPath? {
        
        var indexPathForCell: IndexPath?
        
        for (sectionIndex, section) in sections.enumerated() {
            for (rowIndex, row) in section.rows.enumerated() {
                if cell == row.cell {
                    indexPathForCell = IndexPath(row: rowIndex, section: sectionIndex)
                    break
                } else if let updatedRow = row as? UpdatedRow {
                    if updatedRow.updateAction == .insert{
                        if cell == updatedRow.originalRow.cell {
                            indexPathForCell = IndexPath(row: rowIndex, section: sectionIndex)
                            break
                        }
                    }
                }
            }
        }
        
        return indexPathForCell
    }
    
    // MARK: Updates
    
    open func beginUpdates() {
        CATransaction.begin()
        tableView?.beginUpdates()
    }
    
    open func commitUpdates() {
        var sections = self.sections
        
        for (sectionIndex, section) in sections.enumerated() {
            var rows = section.rows
            
            for (_, row) in section.rows.enumerated() {
                if let row = row as? UpdatedRow {
                    if row.updateAction == .insert {
                        let indexPath  = IndexPath(row: rows.index(of: row)!, section: sectionIndex)
                        let indexPaths = [indexPath]
                        self.tableView?.insertRows(at: indexPaths, with:row.rowAnimation)
                        rows[rows.index(of: row)!] = row.originalRow
                    } else if row.updateAction == .delete {
                        let indexPath  = IndexPath(row: rows.index(of: row)!, section: sectionIndex)
                        let indexPaths = [indexPath]
                        self.tableView?.deleteRows(at: indexPaths, with:row.rowAnimation)
                        rows.remove(at: rows.index(of: row)!)
                    }
                }
            }
            section.rows = rows
        }
        
        for (sectionIndex, section) in sections.enumerated() {
            if let section = section as? UpdatedSection {
                if section.updateAction == .insert {
                    self.tableView?.insertSections(IndexSet(integer: sectionIndex), with: section.rowAnimation)
                    sections[sectionIndex] = section.originalSection
                } else if section.updateAction == .delete {
                    self.tableView?.deleteSections(IndexSet(integer: sectionIndex), with: section.rowAnimation)
                    sections.remove(at: sectionIndex)
                }
            }
        }
        
        self.sections = sections
    }
    
    open func endUpdatesWithCompletionHandler(_ completionHandler: (() -> (Void))?) {
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
    
    open func insert(_ section: Section, at index: Int, with rowAnimation: UITableViewRowAnimation = .automatic) {
        let insertedSection = UpdatedSection(originalSection: section, index: index, updateAction: .insert, rowAnimation: rowAnimation)
        sections.insert(insertedSection, at: index)
    }
    
    open func insert(_ section: Section, before beforeSection: Section, with rowAnimation: UITableViewRowAnimation = .automatic) {
        if let index = index(for: beforeSection) {
            insert(section, at: index, with: rowAnimation)
        }
    }
    
    open func insert(_ section: Section, after afterSection: Section, with rowAnimation: UITableViewRowAnimation = .automatic) {
        if let index = index(for: afterSection) {
            insert(section, at: index + 1, with: rowAnimation)
        }
    }
    
    // MARK: Delete Sections
    
    open func deleteSection(at index: Int, with rowAnimation: UITableViewRowAnimation = .automatic) {
        let section = self.section(at: index)
        let deletedSection = UpdatedSection(originalSection: section, index: index, updateAction: .insert, rowAnimation: rowAnimation)
        sections[index] = deletedSection
    }
    
    open func delete(_ section: Section, with rowAnimation: UITableViewRowAnimation = .automatic) {
        if let index = index(for: section) {
            deleteSection(at: index, with: rowAnimation)
        }
    }
    
    // MARK: Insert Rows
    
    open func insert(_ row: Row, at indexPath:IndexPath, with rowAnimation: UITableViewRowAnimation = .automatic) {
        let section = self.section(at: (indexPath as NSIndexPath).section)
        var rows = Array(section.rows)
        
        let insertedRow = UpdatedRow(originalRow: row, indexPath: indexPath, updateAction: .insert, rowAnimation: rowAnimation)
    
        rows.insert(insertedRow, at: (indexPath as NSIndexPath).row)
        
        section.rows = rows
    }
    
    open func insert(_ row: Row, before beforeRow: Row, with rowAnimation: UITableViewRowAnimation = .automatic) {
        
        if let indexPath = indexPath(for: row) {
            insert(row, at: indexPath, with: rowAnimation)
        }
    }
    
    open func insertRow(_ row: Row, after afterRow: Row, with rowAnimation: UITableViewRowAnimation = .automatic) {
        
        if let indexPath = indexPath(for: afterRow) {
            let afterIndexPath = IndexPath(row: (indexPath as NSIndexPath).row + 1, section: (indexPath as NSIndexPath).section)
            insert(row, at: afterIndexPath, with: rowAnimation)
        }
    }
    
    // MARK: Delete Rows
    
    open func deleteRow(at indexPath: IndexPath, with rowAnimation: UITableViewRowAnimation = .automatic) {
        let section = self.section(at: (indexPath as NSIndexPath).section)
        var rows = Array(section.rows)
        let row = rows[(indexPath as NSIndexPath).row]
        
        let deletedRow = UpdatedRow(originalRow: row, indexPath: indexPath, updateAction: .delete, rowAnimation: rowAnimation)
        
        rows[(indexPath as NSIndexPath).row] = deletedRow
        
        section.rows = rows
    }
    
    open func delete(_ row: Row, with rowAnimation: UITableViewRowAnimation = .automatic) {
        if let indexPath = indexPath(for: row) {
            deleteRow(at: indexPath, with: rowAnimation)
        }
    }
}

private enum DataSourceUpdateAction {
    case insert
    case delete
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
    var indexPath: IndexPath
    var updateAction: DataSourceUpdateAction
    var rowAnimation: UITableViewRowAnimation
    
    init(originalRow: Row, indexPath: IndexPath, updateAction: DataSourceUpdateAction, rowAnimation: UITableViewRowAnimation) {
        self.originalRow = originalRow
        self.indexPath = indexPath
        self.updateAction = updateAction
        self.rowAnimation = rowAnimation
        super.init()
    }
}
