//
//  MockURLSessionDataTask.swift
//  EssentialFeedPracticeTests
//
//  Created by Yash Singh on 5/9/23.
//

import Foundation

class MockURLSessionDataTask: URLSessionDataTask {
    var resumeCallCount: Int = 0
    
    override func resume() {
        resumeCallCount += 1
    }
}

