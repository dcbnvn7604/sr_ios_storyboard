import UIKit

class LoginController: UIViewController {
    @IBOutlet var loginView: LoginView!
    
    override func viewDidLoad() {
        loginView.configure { (username, password) in
            API.shared.login(username: username, password: password) { status in
                switch status {
                case .success:
                    self.dismiss(animated: true, completion: nil)
                case .error:
                    return
                case .fail:
                    return
                }
            }
        }
    }
}
