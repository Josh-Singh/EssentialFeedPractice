//
//  URLSessionMock.swift
//  EssentialFeedPracticeTests
//
//  Created by Yash Singh on 5/9/23.
//

import Foundation

class URLSessionMock: URLSession {
    private var stubs: [URL : URLSessionDataTask] = [:]
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return stubs[url] ?? FakeURLSessionDataTask()
    }
    
    // Stub function helper for recording dataTasks for a given URL
    func stub(url: URL, task: URLSessionDataTask) {
        stubs[url] = task
    }
}
