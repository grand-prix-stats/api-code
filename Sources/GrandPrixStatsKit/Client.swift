import Foundation

public struct Client<Response: Codable> {

    public enum ClientError: Error {
        case requestTimeout
        case invalidResponse
    }

    public init() {}

    public func makeURLRequest(with endpoint: String) -> URLRequest {
        guard let url = URL(string: "https://www.grandprixstats.org/api") else {
            fatalError("Failed to make url")
        }
        return URLRequest(url: url.appendingPathComponent(endpoint))
    }

    public func submit(urlRequest: URLRequest) throws -> Response {
        var responseData: Response?
        let semaphore = DispatchSemaphore(value: 0)
        submit(urlRequest: urlRequest) { (response, error) in
            responseData = response
            semaphore.signal()
        }
        if semaphore.wait(timeout: DispatchTime.now() + 30) == .timedOut {
            throw ClientError.requestTimeout
        }
        guard let response = responseData else {
            throw ClientError.invalidResponse
        }
        return response
    }

    public func submit(urlRequest: URLRequest, completion: @escaping (_ response: Response?, _ error: Error?) -> Void) {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue())
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else {
                completion(nil, error)
                return
            }
            let decoder = JSONDecoder()
            guard let response = try? decoder.decode(Response.self, from: data) else {
                completion(nil, ClientError.invalidResponse)
                return
            }
            completion(response, nil)
        }
        task.resume()
    }

}

// MARK: - Helpers

extension Client {
    public func get(_ endpoint: String) throws -> Response {
        let urlRequest = makeURLRequest(with: endpoint)
        return try submit(urlRequest: urlRequest)
    }

    public func get(_ endpoint: String, completion: @escaping (Response?) -> Void) {
        let urlRequest = makeURLRequest(with: endpoint)
        submit(urlRequest: urlRequest) { (response, error) in
            completion(response)
        }
    }
}
