//
//  HTTPClientMock.swift
//  EssentialFeedPracticeTests
//
//  Created by Yash Singh on 4/6/23.
//

import Foundation

class HTTPClientMock: HTTPClient {
    var requestedURLs = [URL]()     // Added to test how many times the URL is called
    var error: Error?
    func get(from url: URL, completion: @escaping (Error) -> ()) {
        if let error = error {
            completion(error)
        }
        requestedURLs.append(url)
    }
}
