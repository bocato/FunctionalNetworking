//
//  NetworkDispatcher.swift
//  FunctionalNetworking
//
//  Created by Eduardo Bocato on 14/03/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import Foundation

/// This guy is responsible for executing the requests
/// by calling whover we want to use as a client to deal
/// with networking...
public protocol NetworkDispatcher {
    
    /// Our dispatchers environment
    var configuration: NetworkingConfiguration { get }
    
    /// Whe must initialialize the Dispatcher with an environment
    ///
    /// - Parameter environment: environment to send or receive data
    init(configuration: NetworkingConfiguration)
    
    /// Executes the request and provides a completion with the response
    ///
    /// - Parameters:
    ///   - request: the request to be executed
    ///   - completion: the requests callback
    func dispatch(request: Request, completion: @escaping (_ response: Result<Data?, NetworkingError>) -> Void)

}
