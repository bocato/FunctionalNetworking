//
//  ParserProtocol.swift
//  FunctionalNetworking
//
//  Created by Eduardo Bocato on 14/03/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import Foundation

/// This protocol defines a parser interface, in order to extract errors or data from the results of our requests
protocol Parser {
    func parseErrors(in response: NetworkingResponse) -> NetworkingError?
}
