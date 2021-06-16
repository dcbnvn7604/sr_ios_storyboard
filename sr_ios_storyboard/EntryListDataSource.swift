import UIKit

class EntryListDataSource: NSObject {
    private var entryList: [Entry] = []
    
    func load(loadFailed: @escaping () -> Void, loadSuccess: @escaping () -> Void) {
        API.shared.listEntrie() { success, entryList in
            if !success {
                loadFailed()
                return
            }
            self.entryList = entryList!
            loadSuccess()
        }
    }
}

extension EntryListDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryListCell", for: indexPath) as? EntryListCell else {
            fatalError("Can't dequeue EntryListCell")
        }
        let entry = entryList[indexPath.row]
        cell.titleLabel.text = entry.title
        return cell
    }
}
