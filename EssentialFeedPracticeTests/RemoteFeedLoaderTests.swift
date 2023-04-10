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
        
        sut.load { _ in }
        
        XCTAssertNotNil(client.requestedURLs)
        XCTAssertEqual(client.requestedURLs, [url])
    }

    func test_loaddataFromRequestURL_Twice() {
        // Testing the load feed command from API- twice
        let url = URL(string: "https://some-new-url.com")!
        let client = HTTPClientMock()
        let sut = RemoteFeedLoader(client: client, url: url)
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_loadErrorConnectivity() {
        let url = URL(string: "https://some-new-url.com")!
        let client = HTTPClientMock()
        let clientError = NSError(domain: "Test", code: 0)
        let sut = RemoteFeedLoader(client: client, url: url)
//        client.completions[0](clientError)    // !!! Don't call this here we get access array crash! Call after sut.load
        
        
        var capturedError: [RemoteFeedLoader.Error] = []
        sut.load { capturedError.append($0) }               /// Same as `{ error in capturedError.append(error)}`
        client.complete(with: clientError)
        XCTAssertEqual(capturedError, [.connectivity])
    }
    
    func test_loadErrorOnNon200HTTPResponse() {
        let url = URL(string: "https://some-new-url.com")!
        let client = HTTPClientMock()
        var capturedErrors: [RemoteFeedLoader.Error] = []
        
        let sut = RemoteFeedLoader(client: client, url: url)
        sut.load { capturedErrors.append($0) }
        client.complete(withStatusCode: 400)
        XCTAssertEqual(capturedErrors, [.invalidCode])
    }
}
