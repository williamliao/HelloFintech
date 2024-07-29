//
//  EndPoint.swift
//  HelloFintech
//
//  Created by 雲端開發部-廖彥勛 on 2024/7/23.
//

import Foundation

struct EndPointAPI {
    static let scheme = "https"
    static let host = "dimanyen.github.io"
}

protocol EndpointKind {
    associatedtype RequestData

    static func prepare(_ request: inout URLRequest,
                        with data: RequestData)
}

enum EndpointKinds {
    enum Empty: EndpointKind {
        static func prepare(_ request: inout URLRequest,
                            with _: Void) {
            request.cachePolicy = .useProtocolCachePolicy
        }
    }

    enum OnlyFriendList: EndpointKind {
        static func prepare(_ request: inout URLRequest,
                            with _: Void) {
            request.cachePolicy = .useProtocolCachePolicy
        }
    }
    
    enum OnlyFriendList2: EndpointKind {
        static func prepare(_ request: inout URLRequest,
                            with _: Void) {
            request.cachePolicy = .useProtocolCachePolicy
        }
    }
    
    enum FullFriendList: EndpointKind {
        static func prepare(_ request: inout URLRequest,
                            with _: Void) {
            request.cachePolicy = .useProtocolCachePolicy
        }
    }
    
    enum main: EndpointKind {
        static func prepare(_ request: inout URLRequest,
                            with _: Void) {
            request.cachePolicy = .useProtocolCachePolicy
        }
    }
}

struct Endpoint<Kind: EndpointKind, Response: Decodable> {
    var path: String
}

extension Endpoint where Kind == EndpointKinds.Empty, Response == FriendModelRespone {
    static func empty() -> Self {
        return Endpoint(path: "friend4.json")
    }
}

extension Endpoint where Kind == EndpointKinds.OnlyFriendList, Response == FriendModelRespone {
    static func only() -> Self {
        return Endpoint(path: "friend1.json")
    }
}

extension Endpoint where Kind == EndpointKinds.OnlyFriendList2, Response == FriendModelRespone {
    static func only2() -> Self {
        return Endpoint(path: "friend2.json")
    }
}

extension Endpoint where Kind == EndpointKinds.FullFriendList, Response == FriendModelRespone {
    static func full() -> Self {
        return Endpoint(path: "friend3.json")
    }
}

extension Endpoint {
    func makeRequest(with data: Kind.RequestData) -> URLRequest? {
        
        var components = URLComponents()
        
        components.scheme = EndPointAPI.scheme
        components.host = EndPointAPI.host
        
        components.path = "/" + path
        guard let url = components.url else {
            return nil
        }

        var request = URLRequest(url: url)
        Kind.prepare(&request, with: data)
        return request
    }
}
