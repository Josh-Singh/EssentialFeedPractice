//
//  HTTPClientMock.swift
//  EssentialFeedPracticeTests
//
//  Created by Yash Singh on 4/6/23.
//

import Foundation

class HTTPClientMock: HTTPClient {
    var requestedURLs = [URL]()     // Added to test how many times the URL is called
    var completions: [(Error) -> ()] = []
    
    func get(from url: URL, completion: @escaping (Error) -> ()) {
        completions.append(completion)
        requestedURLs.append(url)
    }
    
    func complete(with error: Error, at index: Int = 0) {
        completions[index](error)
    }
}
