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
        
        expect(sut: sut, toCompleteWithError: .connectivity) {
            client.complete(with: clientError)
        }
    }
    
    func test_loadErrorOnNon200HTTPResponse() {
        let url = URL(string: "https://some-new-url.com")!
        let client = HTTPClientMock()
        let sut = RemoteFeedLoader(client: client, url: url)
        
        let invalidCodes = [199, 201, 300, 400, 404, 500]
        invalidCodes.enumerated().forEach { index, code in
            expect(sut: sut, toCompleteWithError: .invalidCode) {
                client.complete(withStatusCode: code, at: index)
            }
        }
    }
    
    func test_200ResponseWithInvalidJSONDataRecieved() {
        let url = URL(string: "https://some-new-url.com")!
        let client = HTTPClientMock()
        let sut = RemoteFeedLoader(client: client, url: url)
        
        expect(sut: sut, toCompleteWithError: .invalidCode) {
            // Below is the action we are testing passed as closure of the expect function
            let invalidJSON = Data(bytes: "invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        }
    }
    
    func test_loadEmptyListOfItemsOn200response() {
        let url = URL(string: "https://some-new-url.com")!
        let client = HTTPClientMock()
        let sut = RemoteFeedLoader(client: client, url: url)
        
        var capturedResults: [RemoteFeedLoader.FeedLoaderResult] = []
        sut.load { capturedResults.append($0) }
        
        let emptyListJSON = Data(bytes: "{\"items\": []}".utf8)
        client.complete(withStatusCode: 200, data: emptyListJSON)
        
        XCTAssertEqual(capturedResults, [.success([])])
    }
    
    // MARK:- Helpers
    private func expect(sut: RemoteFeedLoader,
                        toCompleteWithError error: RemoteFeedLoader.Error,
                        whenExecuting action: () -> (),
                        file: StaticString = #file,
                        line: UInt = #line ) {
        
        /// `file` and `line` are added in the function signature here to make sure that when a failing test occurs the fail message doesn't show up on the `XCTAssertEqual` of the `expect` method but rather in the test itself
        
        var capturedResults: [RemoteFeedLoader.FeedLoaderResult] = []
        sut.load { capturedResults.append($0) }
        
        action()
        XCTAssertEqual(capturedResults, [.failure(error)], file: file, line: line)
    }
}
