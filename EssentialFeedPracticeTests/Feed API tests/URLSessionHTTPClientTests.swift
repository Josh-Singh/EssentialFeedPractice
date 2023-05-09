//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedPracticeTests
//
//  Created by Yash Singh on 5/4/23.
//

import XCTest

class URLSessionHTTPClientTests: XCTestCase {
    
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


