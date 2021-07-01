import UIKit

class TitleEditCell: UITableViewCell {
    @IBOutlet var title: UITextField!
    private var titleChange: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        title.delegate = self
    }
    
    func configure(title:String, titleChange: @escaping (String) -> Void) {
        self.title.text = title
        self.titleChange = titleChange
    }
}

extension TitleEditCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let originalText = textField.text {
            let title = (originalText as NSString).replacingCharacters(in: range, with: string)
            self.titleChange!(title)
        }
        return true
    }
}
