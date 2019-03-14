//
//  Promise.swift
//  FunctionalNetworking
//
//  Created by Eduardo Bocato on 12/03/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import Foundation

public enum PromiseResult<Value> {
    case value(Value)
    case error(Error)
}

public class Future<Value> {
    fileprivate var result: PromiseResult<Value>? {
        didSet { result.map(report) }
    }
    private lazy var callbacks = [(PromiseResult<Value>) -> Void]()
    
    public func observe(with callback: @escaping (PromiseResult<Value>) -> Void) {
        callbacks.append(callback)
        result.map(callback)
    }
    
    private func report(result: PromiseResult<Value>) {
        for callback in callbacks {
            callback(result)
        }
    }
}

extension Future {
    
   public func chained<NextValue>(with closure: @escaping (Value) throws -> Future<NextValue>) -> Future<NextValue> {
        let promise = Promise<NextValue>()
        
        observe { result in
            switch result {
            case .value(let value):
                do {
                    let future = try closure(value)
                    
                    future.observe { result in
                        switch result {
                        case .value(let value):
                            promise.resolve(with: value)
                        case .error(let error):
                            promise.reject(with: error)
                        }
                    }
                } catch {
                    promise.reject(with: error)
                }
            case .error(let error):
                promise.reject(with: error)
            }
        }
        
        return promise
    }
    
    func transformed<NextValue>(with closure: @escaping (Value) throws -> NextValue) -> Future<NextValue> {
        return chained { value in
            return try Promise(value: closure(value))
        }
    }
    
}

class Promise<Value>: Future<Value> {
    
    init(value: Value? = nil) {
        super.init()
        result = value.map(PromiseResult.value)
    }
    
    func resolve(with value: Value) {
        result = .value(value)
    }
    
    func reject(with error: Error) {
        result = .error(error)
    }
    
}
