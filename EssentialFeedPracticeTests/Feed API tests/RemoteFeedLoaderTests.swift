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
        checkForMemoryLeaks(sut: sut, client: client)
    }

    func test_loaddataFromRequestURL_Twice() {
        // Testing the load feed command from API- twice
        let url = URL(string: "https://some-new-url.com")!
        let client = HTTPClientMock()
        let sut = RemoteFeedLoader(client: client, url: url)
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
        checkForMemoryLeaks(sut: sut, client: client)
    }
    
    func test_loadErrorConnectivity() {
        let url = URL(string: "https://some-new-url.com")!
        let client = HTTPClientMock()
        let clientError = NSError(domain: "Test", code: 0)
        let sut = RemoteFeedLoader(client: client, url: url)
        
        expect(sut: sut, toCompleteWithResult: failure(case: .connectivity)) {
            client.complete(with: clientError)
            checkForMemoryLeaks(sut: sut, client: client)
        }
    }
    
    func test_loadErrorOnNon200HTTPResponse() {
        let url = URL(string: "https://some-new-url.com")!
        let client = HTTPClientMock()
        let sut = RemoteFeedLoader(client: client, url: url)
        
        let invalidCodes = [199, 201, 300, 400, 404, 500]
        invalidCodes.enumerated().forEach { index, code in
            expect(sut: sut, toCompleteWithResult: failure(case: .invalidCode)) {
                let jsonData = makeItemsJson(items: [])
                client.complete(withStatusCode: code, data: jsonData, at: index)
                checkForMemoryLeaks(sut: sut, client: client)
            }
        }
    }
    
    func test_200ResponseWithInvalidJSONDataRecieved() {
        let url = URL(string: "https://some-new-url.com")!
        let client = HTTPClientMock()
        let sut = RemoteFeedLoader(client: client, url: url)
        
        expect(sut: sut, toCompleteWithResult: failure(case: .invalidCode)) {
            // Below is the action we are testing passed as closure of the expect function
            let invalidJSON = Data(bytes: "invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
            checkForMemoryLeaks(sut: sut, client: client)
        }
    }
    
    func test_loadEmptyListOfItemsOn200response() {
        let url = URL(string: "https://some-new-url.com")!
        let client = HTTPClientMock()
        let sut = RemoteFeedLoader(client: client, url: url)
        
        expect(sut: sut, toCompleteWithResult: .success([])) {
            let emptyListJSON = makeItemsJson(items: [])
            client.complete(withStatusCode: 200, data: emptyListJSON)
            checkForMemoryLeaks(sut: sut, client: client)
        }
    }
    
    func test_loadListOfItemsOn200Responsee() {
        // aka Happiest path
        let item1 = makeItem(id: UUID(), description: nil, location: nil, imageURL: URL(string: "a-imageURL.com")!)
        
        // JSON representation of data received
        // description and location not added since it is coming back as nil in our representation which is not represented in the JSON
        let item1JSON = item1.json
        
        let item2 = makeItem(id: UUID(), description: "description for item 2", location: "location for item 2", imageURL: URL(string: "a-imageURL.com")!)
        let item2JSON = item2.json
        
        // In our JSON contract we get the response as follows
        /**
         200 Response
                "items": [
                        {
                            "id": "someId"
                            "description": "some description"       // can also be nil so not sent at all
                            "location": "some location"                 // Same as above
                            "image": "some-image-url.com"
                        }
                ]
         */
        let url = URL(string: "https://some-url.com")!
        let client = HTTPClientMock()
        let sut = RemoteFeedLoader(client: client, url: url)
        
        expect(sut: sut, toCompleteWithResult: .success([item1.object, item2.object])) {
            let jsonData = makeItemsJson(items: [item1JSON, item2JSON])
            client.complete(withStatusCode: 200, data: jsonData)
            checkForMemoryLeaks(sut: sut, client: client)
        }
    }
    
    func test_load_doesntDeliverDataAfterFeedLoaderInstanceIsDeallocated() {
        let url = URL(string: "https://someURL.com")!
        let client = HTTPClientMock()
        var sut: RemoteFeedLoader? = RemoteFeedLoader(client: client, url: url)
        var capturedResults: [LoadFeedResult] = []
        
        sut?.load { capturedResults.append($0) }
        sut = nil
        client.complete(withStatusCode: 200, data: makeItemsJson(items: []))
        
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    // MARK:- Helpers
    private func expect(sut: RemoteFeedLoader,
                        toCompleteWithResult expectedResult: LoadFeedResult,
                        whenExecuting action: () -> (),
                        file: StaticString = #file,
                        line: UInt = #line ) {
        
        /// `file` and `line` are added in the function signature here to make sure that when a failing test occurs the fail message doesn't show up on the `XCTAssertEqual` of the `expect` method but rather in the test itself
        
        let exp = expectation(description: "Wait for load completion")
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case (.success(let receivedItems), .success(let expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case (.failure(let receivedError), .failure(let expectedError)):
                XCTAssertEqual(receivedError.localizedDescription, expectedError.localizedDescription, file: file, line: line)
            default:
                XCTFail("Expected result: \(expectedResult) but received result:\(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
    }
    
    private func makeItem(id: UUID,
                          description: String?,
                          location: String?,
                          imageURL: URL
    ) -> (object: FeedItem, json: [String: Any]) {
        let feedItem = FeedItem(id: id, description: description, location: location, imageURL: imageURL)
        let jsonRepresentationOfFeedItem = [
            "id": id.uuidString,
            "description": description,
            "location": location,
            "image": imageURL.absoluteString
        ].compactMapValues { $0 }
        
        return (feedItem, jsonRepresentationOfFeedItem)
    }
    
    private func makeItemsJson(items: [[String: Any]]) -> Data {
        let items = ["items": items]
        return try! JSONSerialization.data(withJSONObject: items)
    }
    
    private func checkForMemoryLeaks(sut: RemoteFeedLoader,
                                     client: HTTPClientMock,
                                     file: StaticString = #file,
                                     line: UInt = #line ) {
        addTeardownBlock { [weak sut, weak client] in
            XCTAssertNil(sut, "SUT instance should be deallocated", file: file, line: line)
            XCTAssertNil(client, "Client instance should be deallocated", file: file, line: line)
        }
    }
    
    private func failure(case error: RemoteFeedLoader.Error) -> LoadFeedResult {
        return .failure(error)
    }
}
