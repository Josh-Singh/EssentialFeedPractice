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
        
        expect(sut: sut, toCompleteWithResult: .failure(.connectivity)) {
            client.complete(with: clientError)
        }
    }
    
    func test_loadErrorOnNon200HTTPResponse() {
        let url = URL(string: "https://some-new-url.com")!
        let client = HTTPClientMock()
        let sut = RemoteFeedLoader(client: client, url: url)
        
        let invalidCodes = [199, 201, 300, 400, 404, 500]
        invalidCodes.enumerated().forEach { index, code in
            expect(sut: sut, toCompleteWithResult: .failure(.invalidCode)) {
                let jsonData = makeItemsJson(items: [])
                client.complete(withStatusCode: code, data: jsonData, at: index)
            }
        }
    }
    
    func test_200ResponseWithInvalidJSONDataRecieved() {
        let url = URL(string: "https://some-new-url.com")!
        let client = HTTPClientMock()
        let sut = RemoteFeedLoader(client: client, url: url)
        
        expect(sut: sut, toCompleteWithResult: .failure(.invalidCode)) {
            // Below is the action we are testing passed as closure of the expect function
            let invalidJSON = Data(bytes: "invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        }
    }
    
    func test_loadEmptyListOfItemsOn200response() {
        let url = URL(string: "https://some-new-url.com")!
        let client = HTTPClientMock()
        let sut = RemoteFeedLoader(client: client, url: url)
        
        expect(sut: sut, toCompleteWithResult: .success([])) {
            let emptyListJSON = Data(bytes: "{\"items\": []}".utf8)
            client.complete(withStatusCode: 200, data: emptyListJSON)
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
        }
    }
    
    // MARK:- Helpers
    private func expect(sut: RemoteFeedLoader,
                        toCompleteWithResult result: RemoteFeedLoader.FeedLoaderResult,
                        whenExecuting action: () -> (),
                        file: StaticString = #file,
                        line: UInt = #line ) {
        
        /// `file` and `line` are added in the function signature here to make sure that when a failing test occurs the fail message doesn't show up on the `XCTAssertEqual` of the `expect` method but rather in the test itself
        
        var capturedResults: [RemoteFeedLoader.FeedLoaderResult] = []
        sut.load { capturedResults.append($0) }
        
        action()
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
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
        ]   // TODO: Use compactMap or something to eliminate description and location values that are nil
        
        return (feedItem, jsonRepresentationOfFeedItem)
    }
    
    private func makeItemsJson(items: [[String: Any]]) -> Data {
        let items = ["items": items]
        return try! JSONSerialization.data(withJSONObject: items)
    }
}
