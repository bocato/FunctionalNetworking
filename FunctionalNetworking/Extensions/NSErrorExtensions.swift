//
//  NSErrorExtensions.swift
//  FunctionalNetworking
//
//  Created by Eduardo Bocato on 14/03/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import Foundation

extension NSError {
    
    /// Shorthand to create errors with a description
    ///
    /// - Parameters:
    ///   - domain: the error domain
    ///   - code: an error code that could be pre-defined (enum, etc)
    ///   - description: a description for the error to be represented
    convenience init(domain: String, code: Int, description: String) {
        self.init(domain: domain, code: code, userInfo: [(kCFErrorLocalizedDescriptionKey as CFString) as String: description])
    }
    
}
