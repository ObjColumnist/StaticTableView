# StaticTableView

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

`StaticTableView` provides a simple API that allows you too quickly build up Static Table Views, while still giving you the ability to dynamically add or remove rows.

`StaticTableView` has 3 core types `DataSource`, `Section` and `Row`.

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

Thats all there is to it, `DataSource`, `Section` and `Row` also have additional properties and methods to help with building Static Table Views.

## Installation

### Carthage

1. Add the following to your *Cartfile*:
  `github "ObjColumnist/StaticTableView"`
2. Run `carthage update`
3. Add the framework as described in [Carthage Readme](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application)
