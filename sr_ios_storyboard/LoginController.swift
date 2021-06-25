import UIKit

class LoginController: UIViewController {
    @IBOutlet var loginView: LoginView!
    
    override func viewDidLoad() {
        loginView.configure { (username, password) in
            API.shared.login(username: username, password: password) { status, token in
                switch status {
                case .success:
                    UserDefaults.standard.set(token!, forKey: "token")
                    self.dismiss(animated: true, completion: nil)
                case .fail:
                    let alertTitle = NSLocalizedString("Login fail", comment: "login fail")
                    let alertMessage = NSLocalizedString("Your username or password incorrect", comment: "login fail message")
                    let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
                    let actionTitle = NSLocalizedString("OK", comment: "ok")
                    alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { _ in
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                case .error:
                    let alertTitle = NSLocalizedString("Login error", comment: "login error")
                    let alertMessage = NSLocalizedString("Something went wrong", comment: "login error message")
                    let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
                    let actionTitle = NSLocalizedString("OK", comment: "ok")
                    alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { _ in
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
