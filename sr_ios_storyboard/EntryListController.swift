import UIKit

class EntryListController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let entryListDataSource = EntryListDataSource()
        tableView.dataSource = entryListDataSource
        entryListDataSource.load(loadFailed: {
            let authentication = self.navigationController!.storyboard!.instantiateViewController(identifier: "authentication")
            authentication.modalPresentationStyle = .fullScreen
            self.present(authentication, animated: true, completion: nil)
        }) {
        }
    }
}

