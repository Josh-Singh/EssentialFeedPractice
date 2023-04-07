//
//  HTTPClientMock.swift
//  EssentialFeedPracticeTests
//
//  Created by Yash Singh on 4/6/23.
//

import Foundation

class HTTPClientMock: HTTPClient {
    var requestedURLs = [URL]()     // Added to test how many times the URL is called
    func get(from url: URL) {
        requestedURLs.append(url)
    }
}
