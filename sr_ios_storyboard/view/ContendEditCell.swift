import UIKit

class ContentEditCell: UITableViewCell {
    @IBOutlet var content: UITextView!
    private var contentChange: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        content.delegate = self
    }
    
    func configure(content: String?, contentChange: @escaping (String) -> Void) {
        self.content.text = content
        self.contentChange = contentChange
    }
}

extension ContentEditCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let originalText = content.text {
            let content = (originalText as NSString).replacingCharacters(in: range, with: text)
            contentChange!(content)
        }
        return true
    }
}
