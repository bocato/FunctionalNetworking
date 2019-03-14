//
//  URLUtil.swift
//  FunctionalNetworking
//
//  Created by Eduardo Bocato on 14/03/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import Foundation

class URLUtil {
    
    /// Provides a simple way to get scaped query parameters
    ///
    /// - Parameter parameters: the parameters for the query
    /// - Returns: an string representing the parameters
    func escapedParameters(_ parameters: [String: Any]) -> String {
        if parameters.isEmpty {
            return ""
        } else {
            var keyValuePairs = [String]()
            for (key, value) in parameters {
                // make sure that it is a string value
                let stringValue = "\(value)"
                // escape it
                let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                // append it
                keyValuePairs.append(key + "=" + "\(escapedValue!)")
            }
            return "?\(keyValuePairs.joined(separator: "&"))"
        }
    }
    
}
