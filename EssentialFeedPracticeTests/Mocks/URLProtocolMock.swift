//
//  URLSessionMock.swift
//  EssentialFeedPracticeTests
//
//  Created by Yash Singh on 5/9/23.
//

import Foundation

class URLProtocolMock: URLProtocol {
    private static var stubs: [URL : Stub] = [:]
    
    private struct Stub {
        let error: Error?
    }
        
    // Stub function helper for recording dataTasks for a given URL
    static func stub(url: URL, error: Error? = nil) {
        stubs[url] = Stub(error: error)
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        guard let url = request.url else { return false }
        return URLProtocolMock.stubs[url] != nil
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let url = request.url, let stubs = URLProtocolMock.stubs[url] else { return }
        
        if let error = stubs.error {
            client?.urlProtocol(self, didFailWithError: error)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
    
    // MARK: Helpers
    static func startInterceptingRequests() {
        URLProtocol.registerClass(URLProtocolMock.self)
    }
    
    static func stopInterceptingRequests() {
        URLProtocol.unregisterClass(URLProtocolMock.self)
        stubs = [:]
    }
}
