//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedPracticeTests
//
//  Created by Yash Singh on 4/6/23.
//

import XCTest

class HTTPClient {
    var requestedURL: URL?
}

class RemoteFeedLoaderTests: XCTestCase {

    func test_init() {
        let client = HTTPClient()
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }

}
