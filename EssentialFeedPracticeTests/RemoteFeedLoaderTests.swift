//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedPracticeTests
//
//  Created by Yash Singh on 4/6/23.
//

import XCTest

class RemoteFeedLoaderTests: XCTestCase {

    func test_initDoesNotRequestURL() {
        let (_, client) = makeSUT()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_loaddataFromRequestURL() {
        // Testing the load feed command from API
        let url = URL(string: "https://some-new-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
        XCTAssertEqual(client.requestedURL, url)
    }
    
    // MARK: Helpers
    private func makeSUT(client: HTTPClientMock = HTTPClientMock(),
                         url: URL = URL(string: "https://some-url.com")!) -> (RemoteFeedLoader, HTTPClient) {
        return (RemoteFeedLoader(client: client, url: url), client)
    }

}
