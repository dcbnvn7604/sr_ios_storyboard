import UIKit

class EntryDetailController: UITableViewController {
    private var entry: Entry?
    private var tmpEntry: Entry?
    private var dataSoure: UITableViewDataSource?
    
    func configure(entry: Entry) {
        editButtonItem.accessibilityIdentifier = "editEntry"
        navigationItem.setRightBarButton(editButtonItem, animated: false)
        self.entry = entry
        toViewMode(last: nil)
    }
    
    func toViewMode(last: (() -> Void)?) {
        if let tmpEntry = tmpEntry, entry != tmpEntry {
            let dataSource = self.dataSoure as! EntryDetailEditDataSource
            dataSource.update() { status in
                self.editButtonItem.isEnabled = true
                if !status {
                    DispatchQueue.main.async {
                        let authentication = self.navigationController!.storyboard!.instantiateViewController(identifier: "authentication")
                        authentication.modalPresentationStyle = .fullScreen
                        self.present(authentication, animated: true, completion: nil)
                    }
                } else {
                    self.entry = self.tmpEntry
                    self.dataSoure = EntryDetailViewDataSource(entry: self.entry!)
                    self.tableView.dataSource = self.dataSoure
                    self.tableView.reloadData()
                    self.navigationItem.leftBarButtonItem = nil
                    last?()
                }
            }
            editButtonItem.isEnabled = false
        } else {
            self.dataSoure = EntryDetailViewDataSource(entry: entry!)
            tableView.dataSource = self.dataSoure
            tableView.reloadData()
            navigationItem.leftBarButtonItem = nil
            last?()
        }
    }
    
    func toEditMode(last: (() -> Void)?) {
        self.dataSoure = EntryDetailEditDataSource(entry: entry!) {
            self.tmpEntry = $0
        }
        tableView.dataSource = self.dataSoure
        tableView.reloadData()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelEdit))
        navigationItem.leftBarButtonItem?.accessibilityIdentifier = "cancelEdit"
        last?()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        if isEditing {
            toViewMode() {
                super.setEditing(editing, animated: animated)
            }
        } else {
            toEditMode() {
                super.setEditing(editing, animated: animated)
            }
        }
    }
    
    @objc
    func cancelEdit() {
        tmpEntry = nil
        setEditing(false, animated: true)
    }
}
