import UIKit

class RegisterController: UIViewController {
    @IBOutlet var resisterView: RegisterView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resisterView.configure() { username, password, repassword in
            API.shared.register(username: username, password: password, repassword: repassword) { status, token, message in
                switch status {
                case API.Status.error:
                    let alertTitle = NSLocalizedString("Register error", comment: "login error")
                    let alertMessage = NSLocalizedString("Something went wrong", comment: "login error message")
                    let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
                    let actionTitle = NSLocalizedString("OK", comment: "ok")
                    alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { _ in
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                case API.Status.fail:
                    let alertTitle = NSLocalizedString("Register fail", comment: "login fail")
                    let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
                    let actionTitle = NSLocalizedString("OK", comment: "ok")
                    alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { _ in
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                case API.Status.success:
                    UserDefaults.standard.set(token!, forKey: "token")
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(RegisterController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
