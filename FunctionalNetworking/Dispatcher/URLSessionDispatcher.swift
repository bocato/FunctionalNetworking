//
//  URLSessionDispatcher.swift
//  FunctionalNetworking
//
//  Created by Eduardo Bocato on 14/03/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import Foundation

public protocol URLSessionProtocol {
    func dataTask(with request: NSURLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

public protocol URLSessionDataTaskProtocol {
    func resume()
    func cancel()
}

// MARK: URLSessionDataTaskProtocol
extension URLSessionDataTask: URLSessionDataTaskProtocol {}

// MARK: - URLSessionProtocol
extension URLSession: URLSessionProtocol {
    public func dataTask(with request: NSURLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        let urlRequest = request as URLRequest
        let task = dataTask(with: urlRequest, completionHandler: completionHandler)
        return task as URLSessionDataTaskProtocol
    }
}

public class URLSessionDispatcher: NetworkDispatcher {
    
    // MARK: - Properties
    public let configuration: NetworkingConfiguration
    private var session: URLSessionProtocol = URLSession.shared
    
    // MARK: - Initialization
    public required init(configuration: NetworkingConfiguration) {
        self.configuration = configuration
    }
    
    public required init(configuration: NetworkingConfiguration, session: URLSessionProtocol = URLSession.shared) {
        self.configuration = configuration
        self.session = session
    }
    
    // MARK: - Public
    
    /// Dispatches a request and returns a promisse with data o errror
    ///
    /// - Parameter request: <#request description#>
    /// - Returns: <#return value description#>
    public func dispatch(request: Request, completion: @escaping (Result<Data?, NetworkingError>) -> Void) {
        
        let path = configurePath(for: request)
        let parameters = configureBodyParameters(for: request)
        let headers = configureHeaders(for: request)
        
        let payload = Data.from(parameters)
        
        guard let urlRequest = self.buildURLRequest(httpMethod: request.method, url: configuration.baseURL, path: path, payload: payload, headers: headers) else {
            completion(.failure(NetworkingError(internalError: .invalidURL)))
            return
        }
        
        let nsURLRequest = urlRequest as NSURLRequest
        
        var networkingError: NetworkingError?
        
        let task = session.dataTask(with: nsURLRequest) { (data, urlResponse, error) in
            
            let httpResponse = urlResponse as? HTTPURLResponse
            
            let networkingResponse = NetworkingResponse(data: data,
                                                        error: error,
                                                        httpResponse: httpResponse,
                                                        request: request)
            
            networkingError = DefaultParser().parseErrors(in: networkingResponse)
            guard networkingError == nil else {
                let error = networkingError ?? NetworkingError(internalError: .unknown)
                completion(.failure(error))
                return
            }
            
            guard let data = networkingResponse.data else {
                completion(.success(nil))
                return
            }
            
            completion(.success(data))
        }
        
        networkingError?.task = task
        
        task.resume()
    }
    
}

// MARK: - Helpers
extension URLSessionDispatcher {
    
    private func configureHeaders(for request: Request) -> [String: String] {
        
        var headers = [String: String]()
        
        configuration.headers.forEach { (key, value) in
            headers[key] = value
        }
       
        request.headers?.forEach { (key, value) in
            headers[key] = value
        }
        
        return headers
    }
    
    private func configurePath(for request: Request) -> String {
        guard let parameters = request.parameters else { return request.path }
        switch parameters {
        case .url(let urlParameters):
            guard let urlParameters = urlParameters else { return request.path }
            return URLUtil().escapedParameters(urlParameters)
        default:
            return request.path
        }
    }
    
    private func configureBodyParameters(for request: Request) -> [String: Any]? {
        guard let parameters = request.parameters else { return nil }
        switch parameters {
        case .body(let bodyParameters):
            guard let bodyParameters = bodyParameters else { return nil }
            return bodyParameters
        default:
            return nil
        }
    }
    
    private func buildURLRequest(httpMethod: HTTPMethod, url: URL, path: String?, payload: Data? = nil, headers: [String:String]? = nil) -> URLRequest? {
        
        var requestURL = url
        if let path = path {
            let fullURL = self.getURL(with: path)
            
            guard let uri = fullURL else {
                return nil
            }
            
            requestURL = uri
        }
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = httpMethod.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = payload
        
        return request
    }
    
    private func getURL(with path: String) -> URL? {
        guard let urlString = configuration.baseURL.appendingPathComponent(path).absoluteString.removingPercentEncoding,
            let requestUrl = URL(string: urlString) else {
                return nil
        }
        return requestUrl
    }
    
}
