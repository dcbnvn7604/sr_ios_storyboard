import UIKit

class EntryListController: UITableViewController {
    private var entryListDataSource: EntryListDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()
        entryListDataSource = EntryListDataSource()
        tableView.dataSource = entryListDataSource
    }
    
    override func viewDidAppear(_ animated: Bool) {
        entryListDataSource!.load(loadFailed: {
            DispatchQueue.main.async {
                let authentication = self.navigationController!.storyboard!.instantiateViewController(identifier: "authentication")
                authentication.modalPresentationStyle = .fullScreen
                self.present(authentication, animated: true, completion: nil)
            }
        }) {
            self.tableView.reloadData()
        }
    }
}

