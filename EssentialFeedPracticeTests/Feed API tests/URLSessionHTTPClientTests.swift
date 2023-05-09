//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedPracticeTests
//
//  Created by Yash Singh on 5/4/23.
//

import XCTest

class URLSessionHTTPClientTests: XCTestCase {
    
    func test_getFromUrl_createsDataTaskFromUrl() {
        let url = URL(string: "http://any-url.com")!
        let mockSession = URLSessionMock()
        let sut = URLSessionHTTPClient(session: mockSession)
        
        sut.get(from: url)
        
        XCTAssertEqual(mockSession.receivedUrls, [url])
    }
}

class URLSessionMock: URLSession {
    var receivedUrls: [URL] = []
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        receivedUrls.append(url)
        return MockURLSessionDataTask()
    }
}

class MockURLSessionDataTask: URLSessionDataTask {}
