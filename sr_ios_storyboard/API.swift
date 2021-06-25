import Foundation

public protocol APIRequestProto {
    func call(url: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}

class APIRequest: APIRequestProto {
    func call(url: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void){
        URLSession.shared.dataTask(with: url, completionHandler: completionHandler).resume()
    }
}

class API {
    static let shared: API = API()
    
    private var apiUrl: String?
    private var token: String?
    
    private var apiRequest: APIRequestProto = APIRequest()
    
    func setAPIURL(apiUrl: String) {
        self.apiUrl = apiUrl
    }
    
    func setToken(_ token: String) {
        self.token = token
    }
    
    func setAPIRequest(_ apiRequest: APIRequestProto) {
        self.apiRequest = apiRequest
    }
    
    enum LoginStatus: Int {
        case success
        case fail
        case error
    }
    
    func login(username: String, password: String, loginHandle:@escaping (LoginStatus, String?) -> Void) {
        guard let apiUrl = self.apiUrl else {
            fatalError("apiUrl unset")
        }
        let url = URL(string: "\(apiUrl)/api/auth/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let json: [String:String] = ["username": username, "password": password]
        request.httpBody = try! JSONSerialization.data(withJSONObject: json)
        self.apiRequest.call(url: request) { data, response, error in
            guard error == nil,
                let response = response as? HTTPURLResponse,
                [200, 400].contains(where: {$0 == response.statusCode}) else {
                loginHandle(LoginStatus.error, nil)
                return
            }
            
            guard response.statusCode == 200 else {
                loginHandle(LoginStatus.fail, nil)
                return
            }
            
            guard let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String],
                let token = json.first(where: { $0.key == "token" })?.value else {
                loginHandle(LoginStatus.error, nil)
                return
            }
            
            self.token = token
            loginHandle(LoginStatus.success, token)
        }
    }
    
    func listEntry(listEntryCompleted: @escaping (Bool, [Entry]?) -> Void) {
        guard let apiUrl = self.apiUrl else {
            fatalError("apiUrl unset")
        }
        
        guard let _ = self.token else {
            listEntryCompleted(false, nil)
            return
        }

        let url = URL(string: "\(apiUrl)/api/entries/")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        self.apiRequest.call(url: request) { data, response, error in
            guard error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data,
                let entryList = try? JSONDecoder().decode([Entry].self, from: data) else {
                listEntryCompleted(false, nil)
                return
            }
            
            listEntryCompleted(true, entryList)
        }
    }
}
