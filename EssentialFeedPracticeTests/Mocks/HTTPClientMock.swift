//
//  HTTPClientMock.swift
//  EssentialFeedPracticeTests
//
//  Created by Yash Singh on 4/6/23.
//

import Foundation

class HTTPClientMock: HTTPClient {
    private var messages: [(url: URL, completion: (HTTPClientResult) -> ())] = []
    var requestedURLs: [URL] {
        messages.map { $0.url }
    }     // Added to test how many times the URL is called
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> ()) {
        messages.append((url: url, completion: completion))
    }
    
    func complete(with error: Error, at index: Int = 0) {
        messages[index].completion(.failure(error))
    }
    
    func complete(withStatusCode code: Int, at index: Int = 0) {
        let response = HTTPURLResponse(
            url: requestedURLs[index],
            statusCode: code,
            httpVersion: nil,
            headerFields: nil)!
        
        messages[index].completion(.success(response))
    }
}
