//
//  DataSourceProvider.swift
//  StaticTableView
//
//  Created by Spencer MacDonald on 14/12/2015.
//  Copyright © 2015 Square Bracket Software. All rights reserved.
//

import UIKit

public protocol DataSourceProvider: UITableViewDataSource, UITableViewDelegate {
    func dataSourceForTableView(tableView: UITableView) -> DataSource
}

public extension DataSourceProvider {
    // MARK: - UITableViewDataSource
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSourceForTableView(tableView).numberOfSections
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceForTableView(tableView).sections[section].numberOfRows
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let row = dataSourceForTableView(tableView).rowAtIndexPath(indexPath)
        
        if let dequeueCellHandler = row.dequeueCellHandler {
            return dequeueCellHandler(row, tableView, indexPath)
        } else {
            return row.cell!
        }
    }
    
    public func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return dataSourceForTableView(tableView).sectionIndexTitles
    }
    
    public func tableView(tableView: UITableView, titleForHeaderInSection index: Int) -> String? {
        return dataSourceForTableView(tableView).sections[index].headerTitle
    }
    
    public func tableView(tableView: UITableView, titleForFooterInSection index: Int) -> String? {
        return dataSourceForTableView(tableView).sections[index].footerTitle
    }
    
    // MARK: - UITableViewDelegate
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let headerHeight = dataSourceForTableView(tableView).sections[section].headerHeight {
            return headerHeight
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let footerHeight = dataSourceForTableView(tableView).sections[section].footerHeight {
            return footerHeight
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let row = dataSourceForTableView(tableView).rowAtIndexPath(indexPath)
        
        if let rowHeight = row.height {
            return rowHeight
        } else {
            return tableView.rowHeight
        }
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = dataSourceForTableView(tableView).rowAtIndexPath(indexPath)
        
        if let didSelectHandler = row.didSelectHandler {
            didSelectHandler(row, tableView, indexPath)
        }
    }
    
    public func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let row = dataSourceForTableView(tableView).rowAtIndexPath(indexPath)
        
        if let didDeselectHandler = row.didDeselectHandler {
            didDeselectHandler(row, tableView, indexPath)
        }
    }
    
    public func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let row = dataSourceForTableView(tableView).rowAtIndexPath(indexPath)
        
        if let didTapAccessoryButtonHandler = row.didTapAccessoryButtonHandler {
            didTapAccessoryButtonHandler(row, tableView, indexPath)
        }
    }
    
    public func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let row = dataSourceForTableView(tableView).rowAtIndexPath(indexPath)
        
        if let editActionsHandler = row.editActionsHandler {
            return editActionsHandler(row, tableView, indexPath)
        } else if let editActions = row.editActions {
            return editActions
        } else {
            return nil
        }
    }
}
