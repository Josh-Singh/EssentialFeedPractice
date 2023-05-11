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
        
        sut.get(from: url) { _ in }
        
        XCTAssertEqual(task.resumeCallCount, 1)
    }
    
    func test_getFromUrl_failsOnRequestError() {
        let url = URL(string: "http://any-url.com")!
        let mockSession = URLSessionMock()
        let error = NSError(domain: "some error", code: 1)
        mockSession.stub(url: url, error: error)
        let sut = URLSessionHTTPClient(session: mockSession)
        
        let expectation = expectation(description: "wait for completion")
        sut.get(from: url) { result in
            switch result {
            case .success(_):
                XCTFail("Expected result with error: \(error), got success result :\(result) instead")
            case .failure(let receivedError as NSError):
                XCTAssertEqual(receivedError, error)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}


