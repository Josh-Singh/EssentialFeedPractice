//
//  MockURLSessionDataTask.swift
//  EssentialFeedPracticeTests
//
//  Created by Yash Singh on 5/9/23.
//

import Foundation

class MockURLSessionDataTask: HTTPSessionDataTask {
    var resumeCallCount: Int = 0
    
    func resume() {
        resumeCallCount += 1
    }
}

