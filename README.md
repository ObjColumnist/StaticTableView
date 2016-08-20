# StaticTableView

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

`StaticTableView` provides a simple API that allows you too quickly build up Static Table Views, while still giving you the ability to dynamically add or remove rows.

StaticTableView has 3 core types `DataSource`, `Section` and `Row`.

A typical implementation would involve adding a `dataSource` property to your view controller:

```swift
let dataSource: StaticTableView.DataSource = StaticTableView.DataSource()
```

Then setting up your Static Table View in `viewDidLoad`:

```swift
let buttonRow = StaticTableView.Row()

buttonRow.dequeueCellHandler = {(row, tableView, indexPath) -> UITableViewCell in
    let tableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
    tableViewCell.textLabel?.text = "Press Me"
    return tableViewCell
}

buttonRow.didSelectHandler = { [weak self] (row, tableView, indexPath) -> Void in
    self?.buttonRowPressed(nil)
}

let buttonSection = StaticTableView.Section(rows: [buttonRow])

dataSource.sections = [buttonSection]
```

Then simply set up your `UITableViewDataSource` to use the `dataSource` property to get its data:

```swift
func numberOfSections(in tableView: UITableView) -> Int {
    return dataSource.numberOfSections
}

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.sections[section].numberOfRows
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { 
    let row = dataSource.row(at: indexPath)
    
    return row.dequeueCellHandler!(row, tableView, indexPath)
}
```

If you have setup any `didSelectHandler` then you will also need to implement the appropriate `UITableViewDelegate` method:

```swift
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let row = dataSource.row(at: indexPath)
    
    if let didSelectHandler = row.didSelectHandler {
        didSelectHandler(row, tableView, indexPath)
    }
}
```

Thats all there is to it, `DataSource`, `Section` and `Row` also have additional properties and methods to help with building static table views:

## DataSource

```swift
public var sections: [Section] = []
    
public var numberOfSections: Int
public var numberOfRows: Int

public var sectionIndexTitles: [String]

public var selectedRows: [Row]

public var isEmpty: Bool

public subscript(index: Int) -> Section
public subscript(indexPath: NSIndexPath) -> Row
 
public func section(at index: Int) -> Section

public func row(at indexPath: NSIndexPath) -> Row
public func cell(at indexPath: NSIndexPath) -> UITableViewCell?
public func object(at indexPath: NSIndexPath) -> AnyObject?

public func index(for section: Section) -> Int?
public func indexPath(for ow: Row) -> NSIndexPath?
public func indexPath(for cell: UITableViewCell) -> NSIndexPath?    
```

## Section

```swift
public var rows: [Row]
    
public var headerHeight: CGFloat?
public var footerHeight: CGFloat?

public var headerTitle: String?
public var footerTitle: String?
public var indexTitle: String?

public var headerView: UIView?
public var footerView: UIView?

public var numberOfRows: Int
public var isEmpty: Bool
public subscript(index: Int) -> Row 

public convenience init(rows: [Row])
public convenience init(objects: [AnyObject])
public convenience init(cells: [UITableViewCell])

public func add(_ row: Row)
public func add(_ cell: UITableViewCell)
public func add(_ object: AnyObject)

public func remove(_ row: Row)
public func remove(_ cell: UITableViewCell)
public func remove(_ object: AnyObject)

public func index(for row: Row) -> Int?
public func index(for cell: UITableViewCell) -> Int?
public func index(for object: AnyObject) -> Int?

public func contains(_ row: Row) -> Bool
public func contains(_ cell: UITableViewCell) -> Bool
public func contains(_ object: AnyObject) -> Bool
```

## Row

```swift
public var cell: UITableViewCell?

public var height: CGFloat?
public var estimatedHeight: CGFloat?

public var editActions: [UITableViewRowAction]?

public var didSelectHandler: ((Row, UITableView, NSIndexPath) -> Void)?
public var didDeselectHandler: ((Row, UITableView, NSIndexPath) -> Void)?

public var didTapAccessoryButtonHandler: ((Row, UITableView, NSIndexPath) -> Void)?

public var heightHandler: ((Row, UITableView, NSIndexPath) -> CGFloat)?

public var editActionsHandler: ((Row, UITableView, NSIndexPath) -> [UITableViewRowAction]?)?

public var dequeueCellHandler: ((Row, UITableView, NSIndexPath) -> UITableViewCell)?

public convenience init(object: AnyObject?)
public convenience init(cell: UITableViewCell)
```

## Installation

### Carthage

1. Add the following to your *Cartfile*:
  `github "ObjColumnist/StaticTableView"`
2. Run `carthage update`
3. Add the framework as described in [Carthage Readme](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application)
