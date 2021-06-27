import UIKit

class EntryDetailController: UITableViewController {
    private var entryDetailDataSource: EntryDetailDataSource?
    
    func configure(entry: Entry) {
        self.entryDetailDataSource = EntryDetailDataSource(entry: entry)
        tableView.dataSource = self.entryDetailDataSource
        tableView.reloadData()
    }
}
