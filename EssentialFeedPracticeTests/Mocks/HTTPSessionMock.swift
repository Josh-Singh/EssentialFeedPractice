//
//  URLSessionMock.swift
//  EssentialFeedPracticeTests
//
//  Created by Yash Singh on 5/9/23.
//

import Foundation

class HTTPSessionMock: HTTPSession {
    private var stubs: [URL : Stub] = [:]
    
    private struct Stub {
        let task: HTTPSessionDataTask
        let error: Error?
    }
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> HTTPSessionDataTask {
        guard let stub = stubs[url] else  {
            fatalError("Couldn't find stub for given URL: \(url)")
        }
        completionHandler(nil, nil, stub.error)
        return stub.task
    }
    
    // Stub function helper for recording dataTasks for a given URL
    func stub(url: URL, task: HTTPSessionDataTask = FakeURLSessionDataTask(), error: Error? = nil) {
        stubs[url] = Stub(task: task, error: error)
    }
}
