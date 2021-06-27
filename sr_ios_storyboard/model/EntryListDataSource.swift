import UIKit

class EntryListDataSource: NSObject {
    private var entryList: [Entry]?
    
    func load(loadFailed: @escaping () -> Void, loadSuccess: @escaping () -> Void) {
        API.shared.listEntry() { success, entryList in
            guard success else {
                loadFailed()
                return
            }

            self.entryList = entryList!
            loadSuccess()
        }
    }
    
    func entry(at row: Int) -> Entry {
        return entryList![row]
    }
}

extension EntryListDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryList!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryListCell", for: indexPath)
        let entry = entryList![indexPath.row]
        cell.textLabel?.text = entry.title
        return cell
    }
}
