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
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_loaddataFromRequestURL() {
        // Testing the load feed command from API
        let url = URL(string: "https://some-new-url.com")!
        let client = HTTPClientMock()
        let sut = RemoteFeedLoader(client: client, url: url)
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURLs)
        XCTAssertEqual(client.requestedURLs, [url])
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
    
    func test_loadErrorConnectivity() {
        let url = URL(string: "https://some-new-url.com")!
        let client = HTTPClientMock()
        let clientError = NSError(domain: "Test", code: 0)
        let sut = RemoteFeedLoader(client: client, url: url)
//        client.completions[0](clientError)
        
        
        var capturedError: [RemoteFeedLoader.Error] = []
        sut.load { capturedError.append($0) }               /// Same as `{ error in capturedError.append(error)}`
        client.complete(with: clientError)
        XCTAssertEqual(capturedError, [.connectivity])
    }
}
