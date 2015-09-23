//
//  ViewController.swift
//  StaticTableView
//
//  Created by Spencer MacDonald on 30/04/2015.
//  Copyright (c) 2015 Square Bracket Software. All rights reserved.
//

import UIKit

public class ViewController: UITableViewController {
    
    public let dataSource = DataSource()
    public var reusableCellIdentifier: String = "Identifier"
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.tableView = tableView
        reloadDataSource()
    }
    
    public func reloadDataSource() {
        
    }

    // MARK: - UITableViewDataSource
    
    public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.numberOfSections
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.sections[section].numberOfRows
    }
    
    // MARK: UITableViewDataSource
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell: UITableViewCell!
        
        let row = dataSource.rowAtIndexPath(indexPath)
        
        if let dequeueCellHandler = row.dequeueCellHandler {
            return dequeueCellHandler(row, tableView, indexPath)
        } else if let tableViewCell = row.cell {
            return tableViewCell
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier(reusableCellIdentifier, forIndexPath: indexPath) 
        }
        
        return cell
    }
    
    public override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let row = dataSource.rowAtIndexPath(indexPath)
        
        if let rowHeight = row.height {
            return rowHeight
        } else {
            return tableView.rowHeight
        }
    }
    
    public override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return dataSource.sectionIndexTitles
    }
    
    public override func tableView(tableView: UITableView, titleForHeaderInSection index: Int) -> String? {
        return dataSource.sections[index].headerTitle
    }
    
    public override func tableView(tableView: UITableView, titleForFooterInSection index: Int) -> String? {
        return dataSource.sections[index].footerTitle
    }
    
    // MARK: - UITableViewDelegate
    
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = dataSource.rowAtIndexPath(indexPath)
        
        if let didSelectHandler = row.didSelectHandler{
            didSelectHandler(row, tableView, indexPath)
        }
    }
    
    public override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let row = dataSource.rowAtIndexPath(indexPath)
        
        if let didDeselectHandler = row.didDeselectHandler{
            didDeselectHandler(row, tableView, indexPath)
        }
    }
    
    public override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let row = dataSource.rowAtIndexPath(indexPath)
        
        if let didTapAccessoryButtonHandler = row.didTapAccessoryButtonHandler{
            didTapAccessoryButtonHandler(row, tableView, indexPath)
        }
    }
    
    public override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let row = dataSource.rowAtIndexPath(indexPath)
        
        if let editActionsHandler = row.editActionsHandler{
            return editActionsHandler(row, tableView, indexPath)
        } else if let editActions = row.editActions{
            return editActions
        } else {
            return nil
        }
    }
}
