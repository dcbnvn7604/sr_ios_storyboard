import UIKit

class EntryDetailController: UITableViewController {
    private var entry: Entry?
    private var tmpEntry: Entry?
    private var dataSoure: UITableViewDataSource?
    private var isNew: Bool?
    private var _setEditing: (() -> Void)?
    var parentInNew: EntryListController?
    
    func configure(entry: Entry?, isNew: Bool = false) {
        editButtonItem.accessibilityIdentifier = "editEntry"
        navigationItem.setRightBarButton(editButtonItem, animated: false)
        self.entry = entry
        self.isNew = isNew
        self.setEditing(isNew, animated: true)
    }
    
    func toViewMode() {
        if isNew! {
            let dataSource = dataSoure as! EntryDetailEditDataSource
            dataSource.add() { status in
                self.addEntryComplete(status: status)
            }
            editButtonItem.isEnabled = false
        } else {
            if let tmpEntry = tmpEntry, entry != tmpEntry {
                let dataSource = self.dataSoure as! EntryDetailEditDataSource
                dataSource.update() { status in
                    self.updateEntryCompete(status: status)
                }
                editButtonItem.isEnabled = false
            } else {
                self.dataSoure = EntryDetailViewDataSource(entry: entry!)
                tableView.dataSource = self.dataSoure
                tableView.reloadData()
                navigationItem.leftBarButtonItem = nil
                self._setEditing?()
            }
        }
    }
    
    func toEditMode() {
        self.dataSoure = EntryDetailEditDataSource(entry: entry) {
            self.tmpEntry = $0
        }
        tableView.dataSource = self.dataSoure
        tableView.reloadData()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelEdit))
        navigationItem.leftBarButtonItem?.accessibilityIdentifier = "cancelEdit"
        self._setEditing?()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        _setEditing = {
            super.setEditing(editing, animated: animated)
        }
        if editing {
            toEditMode()
        } else {
            toViewMode()
        }
    }
    
    @objc
    func cancelEdit() {
        if isNew! {
            dismiss(animated: true, completion: nil)
        } else {
            tmpEntry = nil
            setEditing(false, animated: true)
        }
    }
    
    private func updateEntryCompete(status:Bool) {
        editButtonItem.isEnabled = true
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
            self._setEditing?()
        }
    }
    
    private func addEntryComplete(status: Bool) {
        editButtonItem.isEnabled = true
        if !status {
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let authentication = storyboard.instantiateViewController(identifier: "authentication")
                authentication.modalPresentationStyle = .fullScreen
                self.present(authentication, animated: true, completion: nil)
            }
        } else {
            parentInNew!.reloadEntry()
            dismiss(animated: true, completion: nil)
        }
    }
}
