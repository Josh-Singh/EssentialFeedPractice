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
    
    func test_dataTaskFromUrl_callsResume() {
        let url = URL(string: "http://any-url.com")!
        let mockSession = URLSessionMock()
        let task = MockURLSessionDataTask()
        mockSession.stub(url: url, task: task)
        let sut = URLSessionHTTPClient(session: mockSession)
        
        sut.get(from: url)
        
        XCTAssertEqual(task.resumeCallCount, 1)
    }
}

class URLSessionMock: URLSession {
    var receivedUrls: [URL] = []
    private var stubs: [URL : URLSessionDataTask] = [:]
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        receivedUrls.append(url)
        return stubs[url] ?? FakeURLSessionDataTask()
    }
    
    // Stub function helper for recording dataTasks for a given URL
    func stub(url: URL, task: URLSessionDataTask) {
        stubs[url] = task
    }
}


