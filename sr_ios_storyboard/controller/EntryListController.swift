import UIKit

class EntryListController: UITableViewController {
    private var entryListDataSource = EntryListDataSource()
    
    override func viewDidAppear(_ animated: Bool) {
        entryListDataSource.load(loadFailed: {
            DispatchQueue.main.async {
                let authentication = self.navigationController!.storyboard!.instantiateViewController(identifier: "authentication")
                authentication.modalPresentationStyle = .fullScreen
                self.present(authentication, animated: true, completion: nil)
            }
        }) {
            self.tableView.dataSource = self.entryListDataSource
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EntryDetail" {
            let destination = segue.destination as! EntryDetailController
            let cell = sender as! UITableViewCell
            let rowIndex = tableView.indexPath(for: cell)!.row
            let entry = entryListDataSource.entry(at: rowIndex)
            destination.configure(entry: entry)
        }
    }
}

