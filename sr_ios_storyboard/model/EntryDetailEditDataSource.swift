import UIKit

class EntryDetailEditDataSource: NSObject {
    private var entry: Entry
    private var entryChange: (Entry) -> Void
    
    enum EditSection: Int, CaseIterable {
        case title
        case content
        
        func value(_ entry: Entry) -> String? {
            switch self {
            case .title:
                return entry.title
            case .content:
                return entry.content
            }
        }
    }
    
    init(entry: Entry?, entryChange: @escaping (Entry) -> Void) {
        if let entry = entry {
            self.entry = entry
        } else {
            self.entry = Entry()
        }
        self.entryChange = entryChange
    }
    
    func update(updateHandler: @escaping (Bool) -> Void) {
        API.shared.updateEntry(entry, updateHandler: updateHandler)
    }
    
    func add(addHandler: @escaping (Bool) -> Void) {
        API.shared.addEntry(entry, addHandler: addHandler)
    }
}
 
extension EntryDetailEditDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return EditSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch EditSection(rawValue: section)! {
        case .title:
            return "Title"
        case .content:
            return "Content"
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = EditSection(rawValue: indexPath.section)!
        switch section {
        case .title:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleEditCell", for: indexPath) as! TitleEditCell
            cell.configure(title: entry.title) {
                self.entry.title = $0
                self.entryChange(self.entry)
            }
            return cell
        case .content:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentEditCell", for: indexPath) as! ContentEditCell
            cell.configure(content: entry.content) {
                self.entry.content = $0
                self.entryChange(self.entry)
            }
            return cell
        }
    }
}
