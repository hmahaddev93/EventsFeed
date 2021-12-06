import Foundation

enum HTTPError: Error, Equatable {
    case statusCode(Int)
    case emptyResponse
}
