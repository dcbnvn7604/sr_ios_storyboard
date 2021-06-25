import Foundation

class APIRequestMock:APIRequestProto {
    private var mockData: [(Data?, URLResponse?, Error?)]?
    private var time = 0
    
    init(_ testcase:String) {
        initMockData(testcase)
    }
    
    func call(url: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let (data, response, error) = mockData![time]
        DispatchQueue.main.async {
            completionHandler(data, response, error)
        }
        time += 1
    }
    
    private func initMockData(_ testcase: String) {
        switch testcase {
        case "login":
            let text1 = """
            {
                "token": "token1"
            }
            """
            let text2 = """
            [
                {
                    "id": "1",
                    "title": "title1",
                    "content": "content1"
                },
                {
                    "id": "2",
                    "title": "title2",
                    "content": "content2"
                }
            ]
            """
            mockData = [
                (data(text1), response(200), nil),
                (data(text2), response(200), nil),
            ]
        default:
            fatalError("No testcase")
        }
    }
    
    private func data(_ text: String) -> Data? {
        return text.data(using: .utf8)
    }
    
    private func response(_ statusCode: Int) -> URLResponse? {
        return HTTPURLResponse(url: URL(string: "http://localhost")!, statusCode: statusCode, httpVersion: nil, headerFields: nil)
    }
}
