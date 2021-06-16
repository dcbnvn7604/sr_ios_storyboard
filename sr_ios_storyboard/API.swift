import Foundation

protocol APIRequestProto {
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
    
    var apiRequest: APIRequestProto = APIRequest()
    
    func setAPIURL(apiUrl: String) {
        self.apiUrl = apiUrl
    }
    
    func login(username: String, password: String) {
        guard let apiUrl = self.apiUrl else {
            fatalError("apiUrl unset")
        }
        let url = URL(string: "\(apiUrl)/api/auth/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let json: [String:String] = ["username": username, "password": password]
        request.httpBody = try! JSONSerialization.data(withJSONObject: json)
        self.apiRequest.call(url: request) { data, response, error in
            
        }
    }
    
    func listEntrie(listEntryCompleted: @escaping (Bool, [Entry]?) -> Void) {
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
            if let _ = error {
                listEntryCompleted(false, nil)
                return
            }
        }
    }
}
