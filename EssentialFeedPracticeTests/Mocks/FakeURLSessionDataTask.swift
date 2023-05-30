//
//  FakeURLSessionDataTask.swift
//  EssentialFeedPracticeTests
//
//  Created by Yash Singh on 5/9/23.
//

import Foundation

// This class is to return an empty version of URLSessionDataTask in test implementation if `stub[url]` doesn't have a task associated with it

class FakeURLSessionDataTask: HTTPSessionDataTask {
    func resume() {
        // Overriding this to avoid potential crash
        // Since this is a fake this will be an empty function
    }
}
