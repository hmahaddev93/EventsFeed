import Foundation
import Alamofire

// This is the thinnest layer over Alamofire. This allows the session to be faked, and therefore HTTPClient to be tested

protocol SessionManager_Protocol {
    func request(_ request: URLRequestConvertible, completionHandler: @escaping (AFDataResponse<Data>) -> Void)
}

extension Session: SessionManager_Protocol {
    func request(_ request: URLRequestConvertible, completionHandler: @escaping (AFDataResponse<Data>) -> Void) {
        self.request(request).responseData(completionHandler: completionHandler)
    }
}
