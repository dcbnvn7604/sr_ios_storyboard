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
            let loginText = """
            {
                "token": "token1"
            }
            """
            let entryListText = """
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
                (data(loginText), response(200), nil),
                (data(entryListText), response(200), nil),
            ]
        case "login_fail":
            mockData = [(nil, response(400), nil)]
        case "login_error":
            mockData = [(nil, nil, nil)]
        case "entry_list":
            let entryListText = """
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
            mockData = [(data(entryListText), response(200), nil)]
        case "entry_edit":
            let entryListText = """
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
                (data(entryListText), response(200), nil),
                (nil, response(200), nil)
            ]
        case "entry_edit_fail":
            let entryListText = """
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
                (data(entryListText), response(200), nil),
                (nil, response(400), nil)
            ]
        case "entry_add":
            let entryListText = """
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
                (data(entryListText), response(200), nil),
                (nil, response(201), nil),
                (data(entryListText), response(200), nil)
            ]
        case "entry_add_fail":
            let entryListText = """
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
                (data(entryListText), response(200), nil),
                (nil, response(400), nil),
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
