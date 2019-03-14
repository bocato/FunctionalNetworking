# FunctionalNetworking
Networking layer using Promises and Results

******************************************
* DISCLAIMER: This is not finished yet.  
******************************************


## Setup

```swift
let baseURL = URL(string: "https://something.com")!
let configuration = Configuration(name: "SomeConfig", headers: nil, baseURL: baseURL)
let dispatcher = URLSessionDispatcher(configuration: configuration)
let service = PokemonService(dispatcher: dispatcher)
```

## Requests

```swift
enum PokemonsRequest: Request {
    
    case list(limit: Int?)
    
    var path: String {
        switch self {
        case .list:
            return "pokemon"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .list:
            return .get
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var parameters: RequestParameters? {
        switch self {
        case .list(let limit):
            guard let limit = limit else { return nil }
            return .url(["limit": limit])
        }
    }
    
}
```


## Service

// TODO: Document
