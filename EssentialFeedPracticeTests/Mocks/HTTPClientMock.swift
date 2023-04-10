//
//  HTTPClientMock.swift
//  EssentialFeedPracticeTests
//
//  Created by Yash Singh on 4/6/23.
//

import Foundation

class HTTPClientMock: HTTPClient {
    private var messages: [(url: URL, completion: (Error) -> ())] = []
    var requestedURLs: [URL] {
        messages.map { $0.url }
    }     // Added to test how many times the URL is called
    
    func get(from url: URL, completion: @escaping (Error) -> ()) {
        messages.append((url: url, completion: completion))
    }
    
    func complete(with error: Error, at index: Int = 0) {
        messages[index].completion(error)
    }
}
