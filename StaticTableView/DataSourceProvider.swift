//
//  DataSourceProvider.swift
//  StaticTableView
//
//  Created by Spencer MacDonald on 14/12/2015.
//  Copyright © 2015 Square Bracket Software. All rights reserved.
//

import UIKit

public protocol DataSourceProvider: UITableViewDataSource, UITableViewDelegate {
    func dataSource(for tableView: UITableView) -> DataSource
}

public extension DataSourceProvider where Self: NSObject {
    // MARK: - UITableViewDataSource
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource(for: tableView).numberOfSections
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource(for: tableView).sections[section].numberOfRows
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = dataSource(for: tableView).row(at: indexPath)
        
        if let dequeueCellHandler = row.dequeueCellHandler {
            return dequeueCellHandler(row, tableView, indexPath)
        } else {
            return row.cell!
        }
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return dataSource(for: tableView).sectionIndexTitles
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource(for: tableView).sections[section].headerTitle
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return dataSource(for: tableView).sections[section].footerTitle
    }
    
    // MARK: - UITableViewDelegate
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let headerHeight = dataSource(for: tableView).sections[section].headerHeight {
            return headerHeight
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let footerHeight = dataSource(for: tableView).sections[section].footerHeight {
            return footerHeight
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = dataSource(for: tableView).row(at: indexPath)
        
        if let rowHeight = row.height {
            return rowHeight
        } else {
            return tableView.rowHeight
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = dataSource(for: tableView).row(at: indexPath)
        
        if let didSelectHandler = row.didSelectHandler {
            didSelectHandler(row, tableView, indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let row = dataSource(for: tableView).row(at: indexPath)
        
        if let didDeselectHandler = row.didDeselectHandler {
            didDeselectHandler(row, tableView, indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let row = dataSource(for: tableView).row(at: indexPath)
        
        if let didTapAccessoryButtonHandler = row.didTapAccessoryButtonHandler {
            didTapAccessoryButtonHandler(row, tableView, indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let row = dataSource(for: tableView).row(at: indexPath)
        
        if let editActionsHandler = row.editActionsHandler {
            return editActionsHandler(row, tableView, indexPath)
        } else if let editActions = row.editActions {
            return editActions
        } else {
            return nil
        }
    }
}
