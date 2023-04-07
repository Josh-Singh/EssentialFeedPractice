//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedPracticeTests
//
//  Created by Yash Singh on 4/6/23.
//

import XCTest

class RemoteFeedLoaderTests: XCTestCase {

    func test_initDoesNotRequestURL() {
        let url = URL(string: "https://some-new-url.com")!
        let client = HTTPClientMock()
        let _  = RemoteFeedLoader(client: client, url: url)
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_loaddataFromRequestURL() {
        // Testing the load feed command from API
        let url = URL(string: "https://some-new-url.com")!
        let client = HTTPClientMock()
        let sut = RemoteFeedLoader(client: client, url: url)
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
        XCTAssertEqual(client.requestedURL, url)
    }

    func test_loaddataFromRequestURL_Twice() {
        // Testing the load feed command from API- twice
        let url = URL(string: "https://some-new-url.com")!
        let client = HTTPClientMock()
        let sut = RemoteFeedLoader(client: client, url: url)
        
        sut.load()
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
}
