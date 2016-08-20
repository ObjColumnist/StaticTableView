//
//  ViewController.swift
//  StaticTableView
//
//  Created by Spencer MacDonald on 30/04/2015.
//  Copyright (c) 2015 Square Bracket Software. All rights reserved.
//

import UIKit

open class ViewController: UITableViewController {
    
    open let dataSource = DataSource()
    open var reusableCellIdentifier: String = "Identifier"
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.tableView = tableView
        reloadDataSource()
    }
    
    open func reloadDataSource() {
        
    }

    // MARK: - UITableViewDataSource
    
    open override func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.numberOfSections
    }
    
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.sections[section].numberOfRows
    }
    
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        let row = dataSource.row(at: indexPath)
        
        if let dequeueCellHandler = row.dequeueCellHandler {
            return dequeueCellHandler(row, tableView, indexPath)
        } else {
            return row.cell!
        }
    }
    
    open override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return dataSource.sectionIndexTitles
    }
    
    open override func tableView(_ tableView: UITableView, titleForHeaderInSection index: Int) -> String? {
        return dataSource.sections[index].headerTitle
    }
    
    open override func tableView(_ tableView: UITableView, titleForFooterInSection index: Int) -> String? {
        return dataSource.sections[index].footerTitle
    }
    
    // MARK: - UITableViewDelegate
    
    open override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let headerHeight = dataSource.sections[section].headerHeight {
            return headerHeight
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    open override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let footerHeight = dataSource.sections[section].footerHeight {
            return footerHeight
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    open override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = dataSource.row(at: indexPath)
        
        if let rowHeight = row.height {
            return rowHeight
        } else {
            return tableView.rowHeight
        }
    }
    
    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = dataSource.row(at: indexPath)
        
        if let didSelectHandler = row.didSelectHandler {
            didSelectHandler(row, tableView, indexPath)
        }
    }
    
    open override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let row = dataSource.row(at: indexPath)
        
        if let didDeselectHandler = row.didDeselectHandler {
            didDeselectHandler(row, tableView, indexPath)
        }
    }
    
    open override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let row = dataSource.row(at: indexPath)
        
        if let didTapAccessoryButtonHandler = row.didTapAccessoryButtonHandler {
            didTapAccessoryButtonHandler(row, tableView, indexPath)
        }
    }
    
    open override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let row = dataSource.row(at: indexPath)
        
        if let editActionsHandler = row.editActionsHandler {
            return editActionsHandler(row, tableView, indexPath)
        } else if let editActions = row.editActions {
            return editActions
        } else {
            return nil
        }
    }
}
