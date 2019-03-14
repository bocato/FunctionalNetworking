//
//  NetworkingOperation.swift
//  FunctionalNetworking
//
//  Created by Eduardo Bocato on 14/03/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import Foundation

public struct NetworkingOperation<RequestType: Request, ResponseType: Codable> {
    
    /// The request to be executed
    let request: RequestType
    
    /// Initialization
    ///
    /// - Parameter request: The request for this operation
    public init(request: RequestType) {
        self.request = request
    }
    
    /// Execute an request operation
    ///
    /// - Parameter dispatcher: the dispatcher to perform requests
    /// - Returns: the result of the operation as a promisse
    public func execute(in dispatcher: NetworkDispatcher) -> Future<ResponseType> {
        
        let promise = Promise<ResponseType>()
        
        dispatcher.dispatch(request: request) { (result) in
            
            switch result {
            case .success(let data):
                
                guard let data = data else {
                    promise.reject(with: NetworkingError(internalError: .noData))
                    return
                }
                
                do {
                    let serializedResponse = try JSONDecoder().decode(ResponseType.self, from: data)
                    promise.resolve(with: serializedResponse)
                } catch let error {
                    promise.reject(with: NetworkingError(rawError: error))
                }
            case .failure(let error):
                promise.reject(with: error)
            }
        }
        
        return promise
        
    }
    
}
