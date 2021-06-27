import UIKit

class EntryDetailDataSource: NSObject {
    private var entry: Entry
    
    enum DetailRow: Int, CaseIterable {
        case title
        case content
        
        func display(entry: Entry) -> String {
            switch self {
            case .title:
                return entry.title
            case .content:
                return entry.content
            }
        }
    }
    
    init(entry: Entry) {
        self.entry = entry
        super.init()
    }
}

extension EntryDetailDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DetailRow.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryDetailCell", for: indexPath)
        let detailRow = DetailRow(rawValue: indexPath.row)
        cell.textLabel?.text = detailRow?.display(entry: entry)
        return cell
    }
}
