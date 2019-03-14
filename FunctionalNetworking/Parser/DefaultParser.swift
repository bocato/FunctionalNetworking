//
//  DefaultParser.swift
//  FunctionalNetworking
//
//  Created by Eduardo Bocato on 14/03/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import Foundation

// Defines a default parser for the project, with the basic
class DefaultParser: Parser {
    
    func parseErrors(in response: NetworkingResponse) -> NetworkingError? {
        
        guard let statusCode = response.httpResponse?.statusCode else {
            return NetworkingError(internalError: .unknown)
        }
        
        if !(200...299 ~= statusCode) {
            
            guard response.error == nil else {
                return NetworkingError(internalError: .unknown)
            }
            
            guard 400...499 ~= statusCode, let data = response.data, let jsonString = String(data: data, encoding: .utf8) else {
                return NetworkingError(internalError: .unknown)
            }
            
            return NetworkingError(rawError: response.error,
                                   rawErrorString: jsonString,
                                   rawErrorData: response.data,
                                   response: response.httpResponse,
                                   request: response.request,
                                   task: nil)
            
        }
        
        return nil
        
    }
    
}
