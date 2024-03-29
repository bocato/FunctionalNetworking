//
//  DataExtensions.swift
//  FunctionalNetworking
//
//  Created by Eduardo Bocato on 14/03/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import Foundation

extension Data {
    
    static func from(_ json: [String: Any]?) -> Data? {
        guard let json = json else { return nil }
        return try? JSONSerialization.data(withJSONObject: json, options: [])
    }
    
}
