//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedPracticeTests
//
//  Created by Yash Singh on 4/6/23.
//

import XCTest

class RemoteFeedLoaderTests: XCTestCase {

    func test_initDoesNotRequestURL() {
        let client = HTTPClientMock()
        HTTPClient.shared = client  // To make up for the moving of requestedURL to mock class
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_loaddataFromRequestURL() {
        // Testing the load feed command from API
        let client = HTTPClientMock()
        HTTPClient.shared = client
        let sut = RemoteFeedLoader()
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }

}
