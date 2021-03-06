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
    
    enum Status: Int {
        case success
        case fail
        case error
    }
    
    func login(username: String, password: String, loginHandle:@escaping (Status, String?) -> Void) {
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
                loginHandle(Status.error, nil)
                return
            }
            
            guard response.statusCode == 200 else {
                loginHandle(Status.fail, nil)
                return
            }
            
            guard let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String],
                let token = json.first(where: { $0.key == "token" })?.value else {
                loginHandle(Status.error, nil)
                return
            }
            
            self.token = token
            loginHandle(Status.success, token)
        }
    }
    
    func register(username: String, password: String, repassword: String, registerHandle: @escaping (Status, String?, String?) -> Void) {
        guard let apiUrl = self.apiUrl else {
            fatalError("apiUrl unset")
        }
        let url = URL(string: "\(apiUrl)/api/register/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let json: [String:String] = ["username": username, "password": password, "repassword": repassword]
        request.httpBody = try! JSONSerialization.data(withJSONObject: json)
        self.apiRequest.call(url: request) { data, response, error in
            if error == nil,
                let response = response as? HTTPURLResponse,
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String] {
                if response.statusCode == 201,
                    let token = json.first(where: { $0.key == "token" })?.value {
                    self.token = token
                    registerHandle(Status.success, token, nil)
                    return
                }
                
                if response.statusCode == 400,
                    let error = json.first(where: { $0.key == "error" })?.value {
                    registerHandle(Status.fail, nil, error)
                    return
                }
            }
            
            registerHandle(Status.error, nil, nil)
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
    
    func updateEntry(_ entry: Entry, updateHandler: @escaping (Bool) -> Void) {
        guard let apiUrl = self.apiUrl else {
            fatalError("apiUrl unset")
        }
        
        guard let _ = self.token else {
            fatalError("token unset")
        }
        
        let url = URL(string: "\(apiUrl)/api/entries/\(entry.id!)/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let json: [String:String] = ["title": entry.title!, "content": entry.content!]
        request.httpBody = try! JSONSerialization.data(withJSONObject: json)
        self.apiRequest.call(url: request) { data, response, error in
            guard error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
                updateHandler(false)
                return
            }
            updateHandler(true)
        }
    }
    
    func addEntry(_ entry: Entry, addHandler: @escaping (Bool) -> Void) {
        guard let apiUrl = self.apiUrl else {
            fatalError("apiUrl unset")
        }
        
        guard let _ = self.token else {
            fatalError("token unset")
        }
        
        let url = URL(string: "\(apiUrl)/api/entries/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let json: [String:String] = ["title": entry.title!, "content": entry.content!]
        request.httpBody = try! JSONSerialization.data(withJSONObject: json)
        self.apiRequest.call(url: request) { data, response, error in
            guard error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode == 201 else {
                addHandler(false)
                return
            }
            addHandler(true)
        }
    }
}
