import UIKit

class RegisterView: UIView {
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var repassword: UITextField!
    @IBOutlet var container: UIStackView!
    var error: UILabel?
    var register: ((String, String, String) -> Void)?
    
    func configure(register: @escaping (String, String, String) -> Void) {
        self.register = register
    }
    
    @IBAction func triggerRegister(_ sender: UIButton) {
        guard let register = register else {
            fatalError("RegisterView no confiure ")
        }

        if isValid() {
            register(username.text!, password.text!, repassword.text!)
        }
    }
    
    private func isValid() -> Bool {
        return checkRequire(username, messsage: "Username is required")
            && checkRequire(password, messsage: "Password is required")
            && checkRequire(repassword, messsage: "Repassword is required")
            && check(repassword) {
                guard repassword.text == password.text else {
                    return (false, "Repassword is not matching")
                }
                return (true, nil)
        }
    }
    
    private func checkRequire(_ field: UITextField, messsage: String) -> Bool {
        return check(field) {
            guard let fieldText = field.text, !fieldText.isEmpty else {
                return (false, messsage)
            }
            return (true, nil)
        }
    }
    
    private func check(_ field: UITextField, check: () -> (Bool, String?)) -> Bool {
        let checkResult = check()
        if !checkResult.0 {
            if error == nil {
                error = UILabel()
                error?.textColor = .red
                error?.accessibilityIdentifier = "error"
            }
            error?.text = checkResult.1
            let index = container.arrangedSubviews.firstIndex(of: field)
            container.insertArrangedSubview(error!, at: index! + 1)
        } else {
            if let error = error {
                error.removeFromSuperview()
            }
        }
        return checkResult.0
    }
}
