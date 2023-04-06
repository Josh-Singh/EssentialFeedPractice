//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedPracticeTests
//
//  Created by Yash Singh on 4/6/23.
//

import XCTest

class RemoteFeedLoaderTests: XCTestCase {

    func test_initDoesNotRequestURL() {
        let client = HTTPClient.shared
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_loaddataFromRequestURL() {
        // Testing the load feed command from API
        let client = HTTPClient.shared
        let sut = RemoteFeedLoader()
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }

}
