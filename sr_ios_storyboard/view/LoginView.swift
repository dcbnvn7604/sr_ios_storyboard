import UIKit

class LoginView: UIView {
    typealias LoginHandle = (String, String) -> Void
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    private var login: ((String, String) -> Void)?
    
    func configure(login: @escaping (String, String) -> Void) {
        self.login = login
    }
    
    @IBAction func triggerLogin(_ sender: UIButton) {
        guard let login = login else {
            fatalError("LoginView no confiure")
        }
        
        login(username.text!, password.text!)
    }
}
