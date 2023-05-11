//
//  URLSessionMock.swift
//  EssentialFeedPracticeTests
//
//  Created by Yash Singh on 5/9/23.
//

import Foundation

class URLSessionMock: URLSession {
    private var stubs: [URL : Stub] = [:]
    
    private struct Stub {
        let task: URLSessionDataTask
        let error: Error?
    }
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        guard let stub = stubs[url] else  {
            fatalError("Couldn't find stub for given URL: \(url)")
        }
        completionHandler(nil, nil, stub.error)
        return stub.task
    }
    
    // Stub function helper for recording dataTasks for a given URL
    func stub(url: URL, task: URLSessionDataTask = FakeURLSessionDataTask(), error: Error? = nil) {
        stubs[url] = Stub(task: task, error: error)
    }
}
