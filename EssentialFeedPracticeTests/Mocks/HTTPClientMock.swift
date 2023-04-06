//
//  HTTPClientMock.swift
//  EssentialFeedPracticeTests
//
//  Created by Yash Singh on 4/6/23.
//

import Foundation

class HTTPClientMock: HTTPClient {
    var requestedURL: URL?
    override func get(from url: URL) {
        requestedURL = url
    }
}
