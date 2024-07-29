//
//  Networking+Mock.swift
//  HelloFintech
//
//  Created by 雲端開發部-廖彥勛 on 2024/7/26.
//

import Foundation

protocol Networking {
    func data(
    from url: URL,
    delegate: URLSessionTaskDelegate?
    ) async throws -> (Data, URLResponse)
    
    func data(
        for request: URLRequest,
        delegate: URLSessionTaskDelegate?
    ) async throws -> (Data, URLResponse)
}

extension Networking {
    func data(from url: URL) async throws -> (Data, URLResponse) {
        try await data(from: url, delegate: nil)
    }
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await data(for: request, delegate: nil)
    }
}

extension URLSession: Networking {
   
}

class NetworkingMock: Networking {
    var result = Result<Data, Error>.success(Data())
    var nextResponse: URLResponse!

    init(_ response: (URLResponse?)) {
        self.nextResponse = response
    }

    func data(
        from url: URL,
        delegate: URLSessionTaskDelegate?
    ) async throws -> (Data, URLResponse) {
        return try (result.get(), nextResponse)
    }
    
    func data(
        for request: URLRequest,
        delegate: URLSessionTaskDelegate?
    ) async throws -> (Data, URLResponse) {
        return try (result.get(), nextResponse)
    }
}
