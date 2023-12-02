//
//  Created by Wojciech Chojnacki on 22/05/2021.
//

import Foundation

public enum Network {
    public typealias HTTPHeaders = [String: String]

    public static let notionBaseURL = URL(string: "https://api.notion.com/")!

    public enum HTTPMethod: String {
        case GET, POST, PUT, PATCH, DELETE
    }

    public enum Errors: Error {
        case HTTPError(code: Int)
        case genericError(Error)
    }
}

public protocol NetworkClient: AnyObject {
    func get<R: Decodable>(
        _ url: URL,
        headers: Network.HTTPHeaders,
        completed: @escaping (Result<R, NotionClientError>) -> Void
    )
    
    func get<R: Decodable>(
        _ url: URL,
        headers: Network.HTTPHeaders
    ) async -> Result<R, NotionClientError>
    

    func post<T: Encodable, R: Decodable>(
        _ url: URL,
        body: T,
        headers: Network.HTTPHeaders,
        completed: @escaping (Result<R, NotionClientError>) -> Void
    )
    
    func post<T: Encodable, R: Decodable>(
        _ url: URL,
        body: T,
        headers: Network.HTTPHeaders
    ) async -> Result<R, NotionClientError>

    func patch<T: Encodable, R: Decodable>(
        _ url: URL,
        body: T,
        headers: Network.HTTPHeaders,
        completed: @escaping (Result<R, NotionClientError>) -> Void
    )
    
    func patch<T: Encodable, R: Decodable>(
        _ url: URL,
        body: T,
        headers: Network.HTTPHeaders
    ) async -> Result<R, NotionClientError>

    func delete<T: Encodable, R: Decodable>(
        _ url: URL,
        body: T,
        headers: Network.HTTPHeaders,
        completed: @escaping (Result<R, NotionClientError>) -> Void
    )
    
    func delete<T: Encodable, R: Decodable>(
        _ url: URL,
        body: T,
        headers: Network.HTTPHeaders
    ) async -> Result<R, NotionClientError>
    

    func delete<R: Decodable>(
        _ url: URL,
        headers: Network.HTTPHeaders,
        completed: @escaping (Result<R, NotionClientError>) -> Void
    )
    
    func delete<R: Decodable>(
        _ url: URL,
        headers: Network.HTTPHeaders
    ) async -> Result<R, NotionClientError>
    
}

public class DefaultNetworkClient: NetworkClient {
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    private let session: URLSession

    public init(sessionConfiguration: URLSessionConfiguration) {
        encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(DateFormatter.iso8601Full)

        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)

        session = .init(configuration: sessionConfiguration)
    }

    public func get<R: Decodable>(
        _ url: URL,
        headers: Network.HTTPHeaders,
        completed: @escaping (Result<R, NotionClientError>) -> Void
    ) {
        
        let request = buildRequest(method: .GET, url: url, headers: headers)
        executeRequest(request: request, completed: completed)
    }
    
    public func get<R>(
        _ url: URL,
        headers: Network.HTTPHeaders
    ) async -> Result<R, NotionClientError> where R : Decodable 
    {
        let request = buildRequest(method: .GET, url: url, headers: headers)
        return await executeRequest(request: request)
    }

    public func post<T: Encodable, R: Decodable>(
        _ url: URL,
        body: T,
        headers: Network.HTTPHeaders,
        completed: @escaping (Result<R, NotionClientError>) -> Void
    ) {
        var request = buildRequest(method: .POST, url: url, headers: headers)
        let requestBody: Data

        do {
            requestBody = try encoder.encode(body)
        } catch {
            completed(.failure(.bodyEncodingError(error)))
            return
        }
        Environment.log.trace("BODY:\n " + String(data: requestBody, encoding: .utf8)!)
        request.httpBody = requestBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        executeRequest(request: request, completed: completed)
    }
    
    public func post<T, R>(
        _ url: URL,
        body: T,
        headers: Network.HTTPHeaders
    ) async -> Result<R, NotionClientError> where T : Encodable, R : Decodable
    {
        var request = buildRequest(method: .POST, url: url, headers: headers)
        let requestBody: Data

        do {
            requestBody = try encoder.encode(body)
        } catch {
            return .failure(.bodyEncodingError(error))
        }
        Environment.log.trace("BODY:\n " + String(data: requestBody, encoding: .utf8)!)
        request.httpBody = requestBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return await executeRequest(request: request)
    }

    public func patch<T: Encodable, R: Decodable>(
        _ url: URL,
        body: T,
        headers: Network.HTTPHeaders,
        completed: @escaping (Result<R, NotionClientError>) -> Void
    ) {
        var request = buildRequest(method: .PATCH, url: url, headers: headers)
        let requestBody: Data

        do {
            requestBody = try encoder.encode(body)
        } catch {
            completed(.failure(.bodyEncodingError(error)))
            return
        }

        Environment.log.trace("BODY:\n " + String(data: requestBody, encoding: .utf8)!)

        request.httpBody = requestBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        executeRequest(request: request, completed: completed)
    }
    
    public func patch<T, R>
    (_ url: URL,
     body: T,
     headers: Network.HTTPHeaders
    ) async -> Result<R, NotionClientError> where T : Encodable, R : Decodable
    {
        var request = buildRequest(method: .PATCH, url: url, headers: headers)
        let requestBody: Data

        do {
            requestBody = try encoder.encode(body)
        } catch {
            return .failure(.bodyEncodingError(error))
        }

        Environment.log.trace("BODY:\n " + String(data: requestBody, encoding: .utf8)!)

        request.httpBody = requestBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return await executeRequest(request: request)
    }

    public func delete<R: Decodable>(
        _ url: URL,
        headers: Network.HTTPHeaders,
        completed: @escaping (Result<R, NotionClientError>) -> Void
    ) {
        // swiftlint:disable:next syntactic_sugar
        self.genericDelete(url, body: Optional<Int>.none, headers: headers, completed: completed)
    }
    
    public func delete<R>(
        _ url: URL,
        headers: Network.HTTPHeaders
    ) async -> Result<R, NotionClientError> where R : Decodable 
    {
        await self.genericDelete(url, body: Optional<Int>.none, headers: headers)
    }

    public func delete<T: Encodable, R: Decodable>(
        _ url: URL,
        body: T,
        headers: Network.HTTPHeaders,
        completed: @escaping (Result<R, NotionClientError>) -> Void
    ) {
        self.genericDelete(url, body: body, headers: headers, completed: completed)
    }
    
    public func delete<T, R>(
        _ url: URL,
        body: T,
        headers: Network.HTTPHeaders
    ) async -> Result<R, NotionClientError> where T : Encodable, R : Decodable
    {
        await self.genericDelete(url, body: body, headers: headers)
    }

    private func genericDelete<T: Encodable, R: Decodable>(
        _ url: URL,
        body: T?,
        headers: Network.HTTPHeaders,
        completed: @escaping (Result<R, NotionClientError>) -> Void
    ) {
        var request = buildRequest(method: .DELETE, url: url, headers: headers)
        if let body = body {
            let requestBody: Data

            do {
                requestBody = try encoder.encode(body)
            } catch {
                completed(.failure(.bodyEncodingError(error)))
                return
            }

            Environment.log.trace("BODY:\n " + String(data: requestBody, encoding: .utf8)!)

            request.httpBody = requestBody
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        executeRequest(request: request, completed: completed)
    }
    
    private func genericDelete<T: Encodable, R: Decodable>(
        _ url: URL,
        body: T?,
        headers: Network.HTTPHeaders
    ) async -> Result<R, NotionClientError>
    {
        var request = buildRequest(method: .DELETE, url: url, headers: headers)
        if let body = body {
            let requestBody: Data

            do {
                requestBody = try encoder.encode(body)
            } catch {
                return .failure(.bodyEncodingError(error))
            }

            Environment.log.trace("BODY:\n " + String(data: requestBody, encoding: .utf8)!)

            request.httpBody = requestBody
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return await executeRequest(request: request)
    }

    private func buildRequest(
        method: Network.HTTPMethod,
        url: URL,
        headers: Network.HTTPHeaders
    ) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        for item in headers {
            request.setValue(item.value, forHTTPHeaderField: item.key)
        }

        return request
    }

    private func executeRequest<T: Decodable>(
        request: URLRequest,
        completed: @escaping (Result<T, NotionClientError>) -> Void
    ) {
        Environment.log.debug("Request: \(request.httpMethod ?? "") \(request.url?.absoluteString ?? "")")
        let task = session.dataTask(with: request) { data, response, error in
            var completeResult: Result<T, NotionClientError>?

            if let error = NetworkClientHelpers.extractError(data: data, response: response, error: error) {
                completeResult = .failure(error)
            } else if let data = data {
                Environment.log.trace(String(data: data, encoding: .utf8) ?? "")
                do {
                    Environment.log.trace(String(data: data, encoding: .utf8) ?? "")
                    let result = try self.decoder.decode(T.self, from: data)
                    completeResult = .success(result)
                } catch let decodingError as Swift.DecodingError {
                    completeResult = .failure(.decodingError(decodingError))
                } catch {
                    completeResult = .failure(.genericError(error))
                }
            } else {
                completeResult = .failure(.unsupportedResponseError)
            }

            DispatchQueue.main.async {
                guard let completeResult = completeResult else {
                    fatalError("Something is wrong, no result!")
                }
                completed(completeResult)
            }
        }
        task.resume()
    }
    
    private func executeRequest<T: Decodable>(
        request: URLRequest
    ) async -> Result<T, NotionClientError>{
        Environment.log.debug("Request: \(request.httpMethod ?? "") \(request.url?.absoluteString ?? "")")
        do {
            let (data, _) = try await session.data(for: request)
            Environment.log.trace(String(data: data, encoding: .utf8) ?? "")
            do {
                Environment.log.trace(String(data: data, encoding: .utf8) ?? "")
                let result = try self.decoder.decode(T.self, from: data)
                return .success(result)
            } catch let decodingError as Swift.DecodingError {
                return .failure(.decodingError(decodingError))
            } catch {
                return .failure(.genericError(error))
            }
            
        } catch {
            if let error = NetworkClientHelpers.extractError(data: nil, response: nil, error: error) {
                return .failure(error)
            }
            return .failure(.unsupportedResponseError)
        }
    }
    
    
}
